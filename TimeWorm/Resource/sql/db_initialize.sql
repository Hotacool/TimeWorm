CREATE TABLE TWVersion (
	version	integer NOT NULL primary key
);
CREATE TABLE `TWTimer` (
	`id`	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	'name'			TEXT,
	'information'	TEXT,
	`seconds`	integer NOT NULL,
	`startDate`	TIMESTAMP NOT NULL,
	`fireDate`	TIMESTAMP,
	`state`	integer
);
CREATE TABLE TWEvent (
	id integer primary key autoincrement,
	'name'			TEXT,
	'information'	TEXT,
	'timerId'		integer,
	'time'			TIMESTAMP,
	FOREIGN KEY(timerId) REFERENCES TWTimer(id)
);