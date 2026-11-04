import { applyDecorators, Controller } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';

// Architecture §5.3: every route belongs to one product's group under /v1.
// Each group gets its own guards and rate limits here once they exist. The
// group is also the route's OpenAPI tag, so each generated client has one API
// class per group.
export const ROUTE_GROUPS = ['admin', 'merchant', 'captain', 'customer'] as const;
export type RouteGroup = (typeof ROUTE_GROUPS)[number];

function routeGroupController(group: RouteGroup) {
  return (path = ''): ClassDecorator =>
    applyDecorators(Controller(path ? `${group}/${path}` : group), ApiTags(group));
}

export const AdminController = routeGroupController('admin');
export const MerchantController = routeGroupController('merchant');
export const CaptainController = routeGroupController('captain');
export const CustomerController = routeGroupController('customer');
