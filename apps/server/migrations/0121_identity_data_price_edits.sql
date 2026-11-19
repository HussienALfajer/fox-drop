-- AP §6.3, §9.6.5 «DATA only before activation» (slice 2.31, owner decision
-- 2026-11-19): `menus.edit_prices` is the right to change the prices of a
-- restaurant past test mode, OWN's and OPS's; DATA keeps editing a draft's or
-- a test-mode menu's prices with `restaurants.menus`.
DELETE FROM "identity"."admin_role_permissions"
WHERE "role_code" = 'DATA' AND "permission_code" = 'menus.edit_prices';
