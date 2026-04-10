import { bigint, pgEnum, pgTable, serial, text, timestamp, varchar } from "drizzle-orm/pg-core";
import { createSelectSchema } from "drizzle-zod";

export const originEnum = pgEnum("origin", ["UNKNOWN", "SYSTEM", "USER"]);
export const severityEnum = pgEnum("severity", ["LOW", "MEDIUM", "HIGH", "EMERGENCY"]);

export const alerts = pgTable("alerts", {
  id: serial().primaryKey().unique(),
  device_name: varchar({ length: 255 }),
  first: bigint({ mode: "number" }),
  last: bigint({ mode: "number" }),
  clear: bigint({ mode: "number" }),
  assigned_to: varchar({ length: 255 }),
  severity: severityEnum().default("LOW"),
  message: text(),
  comments: text(),
  occurrences: bigint({ mode: "number" }),
  updated_at: timestamp(),
  created_at: timestamp().defaultNow().notNull(),
  deleted_at: timestamp()
});

export const alertSelectSchema = createSelectSchema(alerts);
