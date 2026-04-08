DO $$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_type typ
		JOIN pg_namespace nsp ON nsp.oid = typ.typnamespace
		WHERE typ.typname = 'origin' AND nsp.nspname = 'public'
	) THEN
		CREATE TYPE "public"."origin" AS ENUM('UNKNOWN', 'SYSTEM', 'USER');
	END IF;
END $$;
DO $$
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM pg_type typ
		JOIN pg_namespace nsp ON nsp.oid = typ.typnamespace
		WHERE typ.typname = 'severity' AND nsp.nspname = 'public'
	) THEN
		CREATE TYPE "public"."severity" AS ENUM('LOW', 'MEDIUM', 'HIGH', 'EMERGENCY');
	END IF;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "alarms" (
	"id" varchar(255) PRIMARY KEY NOT NULL,
	"alarmraisedtime" timestamp with time zone,
	"alarmclearedtime" timestamp with time zone,
	"alarmreportingtime" timestamp with time zone,
	"alarmchangedtime" timestamp with time zone,
	"alarmedobjecttype" varchar(255),
	"perceivedseverity" varchar(255),
	"probablecause" varchar(255),
	"btelementclass" varchar(255),
	"state" varchar(255),
	"externalalarmid" varchar(255),
	"btcustomer" varchar(255),
	"btsourcesystem" varchar(255),
	"btinstancename" varchar(255),
	"btcount" varchar(255),
	"btuserdefined" varchar(255),
	"btntnid" varchar(255),
	"btpewmso" varchar(255),
	"btaffectedcircuit" varchar(255),
	"btservername" varchar(255),
	"btsite" varchar(255),
	"sourcesystemid" varchar(255),
	"ackuserid" varchar(255),
	"acksystemid" varchar(255),
	"ackstate" varchar(255),
	"alarmtype" varchar(255),
	"plannedoutageindicator" varchar(255),
	"category" varchar(255),
	"incidentid" varchar(255),
	"specificproblem" text,
	"alarmdetails" text,
	"isrootcause" boolean,
	"correlatedalarm" jsonb,
	"alarmedobject" jsonb,
	"affectedservice" jsonb,
	"parentalarm" jsonb,
	CONSTRAINT "alarms_id_unique" UNIQUE("id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "changes" (
	"id" serial PRIMARY KEY NOT NULL,
	"change_number" varchar(255),
	"assignment_group" varchar(255),
	"category" varchar(255),
	"short_description" text,
	"assigned_to" varchar(255),
	"planned_start_date" bigint,
	"planned_end_date" bigint,
	"state" varchar(255),
	"close_code" varchar(255),
	"updated_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"deleted_at" timestamp,
	CONSTRAINT "changes_id_unique" UNIQUE("id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "interfaces" (
	"id" serial PRIMARY KEY NOT NULL,
	"region" varchar(255),
	"country" varchar(255),
	"site_name" varchar(255),
	"device_name" varchar(255),
	"name" varchar(255),
	"description" varchar(255),
	"speed" varchar(255),
	"inbound_util" varchar(255),
	"outbound_util" varchar(255),
	"will_be_exception" boolean,
	"overall_exception" varchar(255),
	"status" varchar(255),
	"updated_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"deleted_at" timestamp,
	CONSTRAINT "interfaces_id_unique" UNIQUE("id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "inventory" (
	"id" serial PRIMARY KEY NOT NULL,
	"bfg_hostname" varchar(255),
	"site_cus_type" varchar(255),
	"site_name" varchar(255),
	"site_cus_region" varchar(255),
	"adr_country" varchar(255),
	"msa" varchar(255),
	"lsa" varchar(255),
	"bfg_ip_address" varchar(255),
	"vendor" varchar(255),
	"model" varchar(255),
	"serial_number" varchar(255),
	"final_hw_eovss" varchar(255),
	"hw_eovss_year" varchar(255),
	"final_hw_eol" varchar(255),
	"hw_eol_year" varchar(255),
	"current_ios_version" varchar(255),
	"sw_eol_date" varchar(255),
	"sw_eol_year" varchar(255),
	"ssv_label" varchar(255),
	"site_type" varchar(255),
	"tower" varchar(255),
	"bfg_ntn_type" varchar(255),
	"sw_status" varchar(255),
	"hw_customer_dependency" boolean,
	"sw_customer_dep_dependency" boolean,
	"riverbed" boolean,
	"hw_exceptions" varchar(255),
	"major_minor_sw_version_upgrade" boolean,
	"recommended_ios" boolean,
	"refesh_status" varchar(255),
	"rfq" varchar(255),
	"risk_reference" varchar(255),
	"action" varchar(255),
	"updated_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"deleted_at" timestamp,
	CONSTRAINT "inventory_id_unique" UNIQUE("id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "otel_logs" (
	"time" timestamp with time zone NOT NULL,
	"tag" text,
	"data" jsonb NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "settings" (
	"id" serial PRIMARY KEY NOT NULL,
	"device_name" varchar(255) NOT NULL,
	"ip" varchar(255) NOT NULL,
	"snmp" boolean DEFAULT false NOT NULL,
	"netflow" boolean DEFAULT false NOT NULL,
	"sys_logs" boolean DEFAULT false NOT NULL,
	"is_monitored" boolean DEFAULT false NOT NULL,
	CONSTRAINT "settings_id_unique" UNIQUE("id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "smarts_discovery_status_rgt" (
	"id" serial PRIMARY KEY NOT NULL,
	"man_hostname" varchar(255),
	"ip_address" varchar(255),
	"previous_successful_discovery" boolean,
	"current_discovery_error_message" varchar(255),
	"model" varchar(255),
	"type" varchar(255),
	"certification" varchar(255),
	"apm_name" varchar(255),
	"first_discovered" varchar(255),
	"last_discovered" varchar(255),
	"access_mode" varchar(255),
	"updated_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"deleted_at" timestamp,
	CONSTRAINT "smarts_discovery_status_rgt_id_unique" UNIQUE("id")
);
