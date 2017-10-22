create table if not exists posts (
  id integer primary key autoincrement,
  text varchar(512),
  spawn integer,
  ip varchar(45), -- Maximum length of an IPv6 address.
  is_admin tinyint(1),
  hidden tinyint(1)
);
