/*
# Create limericks table

1. New Tables
- `limericks`
  - `id` (uuid, primary key)
  - `line1` (text, not null) — first line (AABBA pattern, typically 8-9 syllables)
  - `line2` (text, not null) — second line (rhymes with line1)
  - `line3` (text, not null) — third line (shorter, 5-6 syllables)
  - `line4` (text, not null) — fourth line (rhymes with line3)
  - `line5` (text, not null) — fifth line (rhymes with lines 1 and 2)
  - `created_at` (timestamp)
2. Security
- Enable RLS on `limericks`.
- Allow anon + authenticated CRUD because the data is intentionally shared/public (single-tenant, no auth).
*/

CREATE TABLE IF NOT EXISTS limericks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  line1 text NOT NULL,
  line2 text NOT NULL,
  line3 text NOT NULL,
  line4 text NOT NULL,
  line5 text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE limericks ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_limericks" ON limericks;
CREATE POLICY "anon_select_limericks" ON limericks FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_limericks" ON limericks;
CREATE POLICY "anon_insert_limericks" ON limericks FOR INSERT
  TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_limericks" ON limericks;
CREATE POLICY "anon_update_limericks" ON limericks FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_limericks" ON limericks;
CREATE POLICY "anon_delete_limericks" ON limericks FOR DELETE
  TO anon, authenticated USING (true);
