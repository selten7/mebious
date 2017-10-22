create table if not exists bans (
  id integer primary key autoincrement,
  ip varchar(45) -- Maximum length of an IPv6 address.
);
