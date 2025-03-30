# Restore PostreSQL Database

## Deploy Backup

```
helm upgrade --install hedgedoc-backup 61-hedgedoc\hedgedoc-backup -n hedgedoc
```

# Restore PostreSQL Database

restore from sql

```
dropdb  -h $POSTGRES_HOST -U $POSTGRES_USER codimd
createdb  -h $POSTGRES_HOST -U $POSTGRES_USER codimd
psql -h $POSTGRES_HOST -U $POSTGRES_USER -f hedgedoc-sqldump-2025-03-30_cluster4.sql
```

