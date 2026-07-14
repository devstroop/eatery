/*
 * eaterystore.h — C ABI for libeaterystore.
 *
 * A tiny, stable gateway over an embedded SQLite database. The Flutter/Dart
 * side binds these symbols via dart:ffi. The surface is intentionally minimal
 * (a generic SQL gateway) so it scales to every entity without new native code.
 *
 * Conventions:
 *   - All strings are NUL-terminated UTF-8.
 *   - `params_json` is a JSON array of positional bind values for `?`
 *     placeholders, e.g. `[1,"Coffee",null,4.5,true]`. Pass NULL or "[]"
 *     for none.
 *   - es_query returns a heap-allocated JSON array of row objects. The caller
 *     MUST release it with es_free. Returns NULL on error.
 *   - On error, es_exec returns -1 and es_query returns NULL; call
 *     es_last_error for a human-readable message.
 */
#ifndef EATERYSTORE_H
#define EATERYSTORE_H

#ifdef __cplusplus
extern "C" {
#endif

/* Opaque handle to an open store. */
typedef struct EateryStore EateryStore;

/* Open (creating if needed) a database file. Returns NULL on failure. */
EateryStore *es_open(const char *path);

/* Close a store previously returned by es_open. Safe to call with NULL. */
void es_close(EateryStore *store);

/* Execute a statement (or several `;`-separated statements). Binds
 * params_json to the FIRST statement only. Returns affected row count, or
 * -1 on error. */
long long es_exec(EateryStore *store, const char *sql, const char *params_json);

/* Run a query and return a JSON array of row objects (caller frees via
 * es_free). Returns NULL on error. */
char *es_query(EateryStore *store, const char *sql, const char *params_json);

/* Last error message for the store (owned by the store; do not free). */
const char *es_last_error(EateryStore *store);

/* Free a buffer returned by es_query. Safe to call with NULL. */
void es_free(char *ptr);

/* Version of libeaterystore (static string; do not free). */
const char *es_version(void);

#ifdef __cplusplus
}
#endif

#endif /* EATERYSTORE_H */
