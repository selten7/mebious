create table if not exists images (
  id integer primary key autoincrement,
  url varchar(32),
  spawn integer,
  ip varchar(45), -- Maximum length of an IPv6 address.
  checksum varchar(512)
);
