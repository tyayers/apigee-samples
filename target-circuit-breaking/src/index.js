/**
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import express from 'express';
import { rateLimit } from "express-rate-limit";

const app = express();

app.use(express.json()); // for json data

const applyRateLimit = process.env.APPLY_RATE_LIMIT;

const v1Limiter = rateLimit({
  windowMs: 1 * 60 * 1000,
  limit: 10,
  standardHeaders: true,
  legacyHeaders: false,
});

if (applyRateLimit == "true") {
  app.get('/v1/process', v1Limiter, async (req, res) => {

    res.send('Hello Process v1!');
  });
} else {
  app.get('/v1/process', async (req, res) => {

    res.send('Hello Process v1!');
  });
}

app.get('/v2/process', async (req, res) => {

    res.send('Hello Process v2!');
});

app.listen(8080, () => {
  console.log(`App listening on port 8080.`)
});