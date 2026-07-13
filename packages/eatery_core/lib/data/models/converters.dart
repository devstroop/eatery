DateTime epochFromJson(int v) => DateTime.fromMillisecondsSinceEpoch(v);
int epochToJson(DateTime d) => d.millisecondsSinceEpoch;

DateTime? epochFromJsonNullable(int? v) =>
    v != null ? DateTime.fromMillisecondsSinceEpoch(v) : null;

int? epochToJsonNullable(DateTime? d) => d?.millisecondsSinceEpoch;

int boolToInt(bool v) => v ? 1 : 0;
bool intToBool(int v) => v == 1;
