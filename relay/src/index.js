import Fastify from 'fastify';
import cors from '@fastify/cors';
import { createClient } from '@clickhouse/client';

const {
  CLICKHOUSE_URL = 'http://clickhouse:8123',
  CLICKHOUSE_USER = 'default',
  CLICKHOUSE_PASSWORD = '',
  CLICKHOUSE_DATABASE = 'myt_metrics',
  CLICKHOUSE_PREFIX = 'myt',
  RELAY_PORT = '4001',
  CORS_ALLOW_ORIGIN = '*',
} = process.env;

const ch = createClient({
  host: CLICKHOUSE_URL,
  username: CLICKHOUSE_USER,
  password: CLICKHOUSE_PASSWORD,
  database: CLICKHOUSE_DATABASE,
});

const app = Fastify({ logger: true });
await app.register(cors, { origin: CORS_ALLOW_ORIGIN });

// health
app.get('/health', async () => {
  try {
    const r = await fetch(`${CLICKHOUSE_URL}/ping`);
    const pong = (await r.text()).trim();
    return { ok: pong === 'Ok.', ch: pong };
  } catch (e) {
    return { ok: false, error: String(e) };
  }
});

// bulk insert
app.post('/metrics/insertRows', async (req, reply) => {
  const { rows } = req.body ?? {};
  if (!Array.isArray(rows) || rows.length === 0) {
    return reply.code(400).send({ error: 'rows[] required' });
  }
  const table = `${CLICKHOUSE_PREFIX}_metrics_raw`;
  await ch.insert({ table, values: rows, format: 'JSONEachRow' });
  return { ok: true, sent: rows.length };
});

// dev SQL passthrough (for quick checks)
app.post('/dev/sql', async (req, reply) => {
  const { sql } = req.body ?? {};
  if (!sql) return reply.code(400).send({ error: 'sql required' });
  const res = await ch.query({ query: sql, format: 'JSON' });
  return res.json();
});

app.listen({ host: '0.0.0.0', port: Number(RELAY_PORT) });
