import { createClient } from '@libsql/client';

const db = createClient({
  url: process.env.TURSO_DATABASE_URL,
  authToken: process.env.TURSO_AUTH_TOKEN,
});

export default async function handler(req, res) {
  if (req.method === 'GET') {
    const result = await db.execute('SELECT id, line1, line2, line3, line4, line5, created_at FROM limericks ORDER BY created_at DESC LIMIT 100');
    return res.json(result.rows);
  }

  if (req.method === 'POST') {
    const { line1, line2, line3, line4, line5 } = req.body;
    if (!line1 || !line2 || !line3 || !line4 || !line5) {
      return res.status(400).json({ error: 'All five lines are required' });
    }
    const result = await db.execute({
      sql: 'INSERT INTO limericks (line1, line2, line3, line4, line5) VALUES (?, ?, ?, ?, ?)',
      args: [line1.trim(), line2.trim(), line3.trim(), line4.trim(), line5.trim()],
    });
    return res.json({ id: Number(result.lastInsertRowid) });
  }

  return res.status(405).json({ error: 'Method not allowed' });
}
