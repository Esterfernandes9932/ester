-- ============================================================
-- LogTrain — Schema Supabase
-- Execute este SQL no Supabase Dashboard > SQL Editor
-- ============================================================

-- Tabela de usuários/perfis do app
CREATE TABLE IF NOT EXISTS logtrain_users (
  id          TEXT PRIMARY KEY,
  name        TEXT NOT NULL,
  pin         TEXT DEFAULT '',
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Dados pessoais de cada usuário (histórico, medidas, etc.)
CREATE TABLE IF NOT EXISTS logtrain_user_data (
  user_id         TEXT PRIMARY KEY REFERENCES logtrain_users(id) ON DELETE CASCADE,
  history         JSONB DEFAULT '[]',
  measurements    JSONB DEFAULT '[]',
  workouts        JSONB DEFAULT '[]',
  sessions        JSONB DEFAULT '[]',
  checkins        JSONB DEFAULT '{}',
  photos          JSONB DEFAULT '{}',
  schedule_config JSONB DEFAULT 'null',
  view            TEXT  DEFAULT 'home',
  sort_order      TEXT  DEFAULT 'cronologica',
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Dados compartilhados entre todos (grupos, feed)
CREATE TABLE IF NOT EXISTS logtrain_shared (
  key         TEXT PRIMARY KEY,
  data        JSONB DEFAULT '[]',
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Inicializa as linhas de dados compartilhados
INSERT INTO logtrain_shared (key, data)
VALUES ('groups', '[]'), ('feed', '[]')
ON CONFLICT (key) DO NOTHING;

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_users_updated
  BEFORE UPDATE ON logtrain_users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE OR REPLACE TRIGGER trg_user_data_updated
  BEFORE UPDATE ON logtrain_user_data
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE OR REPLACE TRIGGER trg_shared_updated
  BEFORE UPDATE ON logtrain_shared
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- RLS: desabilitado para app familiar (acesso via anon key)
-- Se quiser mais segurança depois, habilite e configure políticas.
ALTER TABLE logtrain_users     DISABLE ROW LEVEL SECURITY;
ALTER TABLE logtrain_user_data DISABLE ROW LEVEL SECURITY;
ALTER TABLE logtrain_shared    DISABLE ROW LEVEL SECURITY;

-- Garante que a anon key pode fazer CRUD
GRANT ALL ON logtrain_users     TO anon, authenticated;
GRANT ALL ON logtrain_user_data TO anon, authenticated;
GRANT ALL ON logtrain_shared    TO anon, authenticated;
