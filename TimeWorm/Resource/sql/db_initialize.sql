CREATE TABLE TWVersion (
	version	integer NOT NULL primary key
);
CREATE TABLE `TWTimer` (
	`id`	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	'name'			TEXT,
	'information'	TEXT,
	`allSec`	integer NOT NULL,
	`rmdSec`	integer NOT NULL,
	`startDate`	TIMESTAMP NOT NULL,
	`fireDate`	TIMESTAMP,
	`state`	integer
);
CREATE TABLE TWEvent (
	id integer primary key autoincrement,
	'name'			TEXT,
	'information'	TEXT,
	'timerId'		integer NOT NULL,
	`startDate`	TIMESTAMP NOT NULL,
	`stopDate`	TIMESTAMP,
	FOREIGN KEY(timerId) REFERENCES TWTimer(id)
);
##enable foreign key
PRAGMA foreign_keys = ON;