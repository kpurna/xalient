import { createRouter } from "../../lib/create-app.js";
import * as handlers from "./logs.js";
import * as routes from "./logs.routes.js";

const router = createRouter().openapi(routes.getLogs, handlers.getLogs);

export default router;
