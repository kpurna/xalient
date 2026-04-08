import { StatusCodes } from "http-status-codes";
import type { AppRouteHandler } from "../../lib/types.ts";

import { and, gte, lte, eq } from "drizzle-orm";
import db from "../../db/index.js";
import { otelLogs } from "../../db/schema/otelLogs.js";
import type { GetLogs } from "./logs.routes.js";

export const getLogs: AppRouteHandler<GetLogs> = async (c) => {
  const { startTime, endTime, tag, limit } = c.req.valid("query");

  const conditions = [
    startTime ? gte(otelLogs.time, new Date(startTime)) : undefined,
    endTime ? lte(otelLogs.time, new Date(endTime)) : undefined,
    tag ? eq(otelLogs.tag, tag) : undefined
  ].filter(Boolean) as Parameters<typeof and>;

  const logs = await db
    .select()
    .from(otelLogs)
    .where(and(...conditions))
    .limit(limit ?? 100)
    .orderBy(otelLogs.time);

  const serialized = logs.map((log) => ({
    ...log,
    time: log.time.toISOString()
  }));

  return c.json({ data: serialized }, StatusCodes.OK);
};
