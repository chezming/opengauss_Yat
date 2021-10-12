-- @testpoint: 对分区p3进行聚集
drop table if exists inventory_p1;
CREATE TABLE inventory_p1
(
    INV_DATE_SK               INTEGER               NOT NULL,
    INV_ITEM_SK               INTEGER               NOT NULL,
    INV_WAREHOUSE_SK          INTEGER               NOT NULL,
    INV_QUANTITY_ON_HAND      INTEGER
)
PARTITION BY RANGE(INV_DATE_SK)
(
        PARTITION P1 VALUES LESS THAN(2451179),
        PARTITION P2 VALUES LESS THAN(2451544),
        PARTITION P3 VALUES LESS THAN(2451910),
        PARTITION P4 VALUES LESS THAN(2452275),
        PARTITION P5 VALUES LESS THAN(2452640),
        PARTITION P6 VALUES LESS THAN(2453005),
        PARTITION P7 VALUES LESS THAN(MAXVALUE)
);


CREATE INDEX ds_inventory_p1_index1 ON inventory_p1 (INV_ITEM_SK) LOCAL;

CLUSTER inventory_p1 PARTITION (p3) USING ds_inventory_p1_index1;
drop table if exists inventory_p1;