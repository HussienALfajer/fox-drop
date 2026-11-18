import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, isNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { favourites } from './schema.js';

// CU §9.6 «المفضلة» (U18; slice 2.28b): the restaurants an account hearted.
// They belong to the account, so every device reads the same.
@Injectable()
export class FavouritesService {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  // The heart: idempotent by its nature (a favourite already there stays as
  // it was added).
  async add(accountId: string, restaurantId: string, at: Date): Promise<void> {
    await this.database.db
      .insert(favourites)
      .values({ accountId, restaurantId, addedAt: at })
      .onConflictDoUpdate({
        target: [favourites.accountId, favourites.restaurantId],
        set: { addedAt: at, removedAt: null },
        setWhere: sql`${favourites.removedAt} IS NOT NULL`,
      });
  }

  // Removing the heart: nothing to do when it is not a favourite.
  async remove(accountId: string, restaurantId: string, at: Date): Promise<void> {
    await this.database.db
      .update(favourites)
      .set({ removedAt: at })
      .where(
        and(
          eq(favourites.accountId, accountId),
          eq(favourites.restaurantId, restaurantId),
          isNull(favourites.removedAt),
        ),
      );
  }

  // The account's favourites, the latest added first.
  async ids(accountId: string): Promise<string[]> {
    const rows = await this.database.db
      .select({ restaurantId: favourites.restaurantId })
      .from(favourites)
      .where(and(eq(favourites.accountId, accountId), isNull(favourites.removedAt)))
      .orderBy(desc(favourites.addedAt));
    return rows.map((row) => row.restaurantId);
  }
}
