defmodule LocWise.Repo.Migrations.AddUnaccent do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS unaccent"

    execute """
    CREATE OR REPLACE FUNCTION f_unaccent(regdictionary, text)
      RETURNS text
      LANGUAGE c IMMUTABLE PARALLEL SAFE STRICT AS
    '$libdir/unaccent', 'unaccent_dict';
    """

    execute """
    CREATE OR REPLACE FUNCTION f_unaccent(text)
      RETURNS text
      LANGUAGE sql IMMUTABLE PARALLEL SAFE STRICT AS
    $func$
    SELECT f_unaccent('unaccent', $1)
    $func$;
    """
  end
end
