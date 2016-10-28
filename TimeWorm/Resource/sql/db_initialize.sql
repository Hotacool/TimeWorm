CREATE TABLE TWVersion (
	version	integer NOT NULL primary key
);
CREATE TABLE `TWTimer` (
	`ID`	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	'name'			TEXT,
	'information'	TEXT,
	`allSeconds`	integer NOT NULL,
	`remainderSeconds`	integer NOT NULL,
	`startDate`	TIMESTAMP NOT NULL,
	`fireDate`	TIMESTAMP,
	`state`	integer
);
CREATE TABLE TWEvent (
	ID integer primary key autoincrement,
	'name'			TEXT,
	'information'	TEXT,
	'timerId'		integer NOT NULL,
	`startDate`	TIMESTAMP NOT NULL,
	`stopDate`	TIMESTAMP,
	FOREIGN KEY(timerId) REFERENCES TWTimer(ID)
);

CREATE TABLE `TWSet` (
	`ID`	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	`homeTheme`	integer,
	`workTheme`	integer,
	`relaxTheme`	integer,
	`keepAwake`	boolean,
	`defaultTimer`	integer default 15,
	'defaultTimerName'	TEXT,
	'defaultTimerInf'	TEXT,
	`keepTimer`	boolean,
	`isNotifyOn`	boolean
);

PRAGMA foreign_keys = ON;
