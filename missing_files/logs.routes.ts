import { createRoute, z } from "@hono/zod-openapi";
import { ReasonPhrases, StatusCodes } from "http-status-codes";

export const getLogs = createRoute({
  path: "api/logs",
  method: "get",
  tags: ["Logs"],
  request: {
    query: z.object({
      startTime: z.coerce.number().optional(),
      endTime: z.coerce.number().optional(),
      tag: z.string().optional(),
      limit: z.coerce.number().optional().default(100)
    })
  },
  responses: {
    [StatusCodes.OK.valueOf()]: {
      description: ReasonPhrases.OK,
      content: {
        "application/json": {
          schema: z.object({
            data: z.array(
              z.object({
                time: z.string(),
                tag: z.string().nullable(),
                data: z.record(z.unknown())
              })
            )
          })
        }
      }
    }
  }
});

export type GetLogs = typeof getLogs;
