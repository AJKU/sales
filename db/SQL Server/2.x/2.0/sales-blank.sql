﻿-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/01.types-domains-tables-and-constraints/tables-and-constraints.sql --<--<--
EXECUTE dbo.drop_schema 'sales';
GO
CREATE SCHEMA sales;
GO


--TODO: CREATE UNIQUE INDEXES

CREATE TABLE sales.gift_cards
(
    gift_card_id                            integer IDENTITY PRIMARY KEY,
    gift_card_number                        national character varying(100) NOT NULL,
    payable_account_id                        integer NOT NULL REFERENCES finance.accounts,
    customer_id                             integer REFERENCES inventory.customers,
    first_name                              national character varying(100),
    middle_name                             national character varying(100),
    last_name                               national character varying(100),
    address_line_1                          national character varying(128),   
    address_line_2                          national character varying(128),
    street                                  national character varying(100),
    city                                    national character varying(100),
    state                                   national character varying(100),
    country                                 national character varying(100),
    po_box                                  national character varying(100),
    zipcode                                 national character varying(100),
    phone_numbers                           national character varying(100),
    fax                                     national character varying(100),    
    audit_user_id                           integer REFERENCES account.users,
    audit_ts                                DATETIMEOFFSET DEFAULT(GETDATE()),
    deleted                                    bit DEFAULT(0)    
);

CREATE UNIQUE INDEX gift_cards_gift_card_number_uix
ON sales.gift_cards(gift_card_number)
WHERE deleted = 0;

--TODO: Create a trigger to disable deleting a gift card if the balance is not zero.

CREATE TABLE sales.gift_card_transactions
(
    transaction_id                          bigint IDENTITY PRIMARY KEY,
    gift_card_id                            integer NOT NULL REFERENCES sales.gift_cards,
    value_date                                date,
    book_date                                date,
    transaction_master_id                   bigint NOT NULL REFERENCES finance.transaction_master,
    transaction_type                        national character varying(2) NOT NULL
                                            CHECK(transaction_type IN('Dr', 'Cr')),
    amount                                  decimal(30, 6)
);

CREATE TABLE sales.late_fee
(
    late_fee_id                             integer IDENTITY PRIMARY KEY,
    late_fee_code                           national character varying(24) NOT NULL,
    late_fee_name                           national character varying(500) NOT NULL,
    is_flat_amount                          bit NOT NULL DEFAULT(0),
    rate                                    numeric(30, 6) NOT NULL,
    account_id                                 integer NOT NULL REFERENCES finance.accounts,
    audit_user_id                           integer REFERENCES account.users,
    audit_ts                                DATETIMEOFFSET DEFAULT(GETDATE()),
    deleted                                    bit DEFAULT(0)
);

CREATE TABLE sales.late_fee_postings
(
    transaction_master_id                   bigint PRIMARY KEY REFERENCES finance.transaction_master,
    customer_id                             integer NOT NULL REFERENCES inventory.customers,
    value_date                              date NOT NULL,
    late_fee_tran_id                        bigint NOT NULL REFERENCES finance.transaction_master,
    amount                                  decimal(30, 6)
);

CREATE TABLE sales.price_types
(
    price_type_id                           integer IDENTITY PRIMARY KEY,
    price_type_code                         national character varying(24) NOT NULL,
    price_type_name                         national character varying(500) NOT NULL,
    audit_user_id                           integer REFERENCES account.users,
    audit_ts                                DATETIMEOFFSET DEFAULT(GETDATE()),
    deleted                                    bit DEFAULT(0)
);

CREATE TABLE sales.item_selling_prices
(
    item_selling_price_id                   bigint IDENTITY PRIMARY KEY,
    item_id                                 integer NOT NULL REFERENCES inventory.items,
    unit_id                                 integer NOT NULL REFERENCES inventory.units,
    customer_type_id                        integer REFERENCES inventory.customer_types,
    price_type_id                           integer REFERENCES sales.price_types,
    includes_tax                            bit NOT NULL DEFAULT(0),
    price                                   decimal(30, 6) NOT NULL,
    audit_user_id                           integer REFERENCES account.users,
    audit_ts                                DATETIMEOFFSET DEFAULT(GETDATE()),
    deleted                                    bit DEFAULT(0)
);

CREATE TABLE sales.payment_terms
(
    payment_term_id                         integer IDENTITY PRIMARY KEY,
    payment_term_code                       national character varying(24) NOT NULL,
    payment_term_name                       national character varying(500) NOT NULL,
    due_on_date                             bit NOT NULL DEFAULT(0),
    due_days                                integer NOT NULL DEFAULT(0),
    due_frequency_id                        integer REFERENCES finance.frequencies,
    grace_period                            integer NOT NULL DEFAULT(0),
    late_fee_id                             integer REFERENCES sales.late_fee,
    late_fee_posting_frequency_id           integer REFERENCES finance.frequencies,
    audit_user_id                           integer REFERENCES account.users,
    audit_ts                                DATETIMEOFFSET DEFAULT(GETDATE()),
    deleted                                    bit DEFAULT(0)    
);


CREATE TABLE sales.cashiers
(
    cashier_id                              integer IDENTITY PRIMARY KEY,
    cashier_code                            national character varying(12) NOT NULL,
    pin_code                                national character varying(8) NOT NULL,
    associated_user_id                      integer NOT NULL REFERENCES account.users,
    counter_id                              integer NOT NULL REFERENCES inventory.counters,
    valid_from                              date NOT NULL,
    valid_till                              date NOT NULL,
                                            CHECK(valid_till >= valid_from),
    audit_user_id                           integer REFERENCES account.users,
    audit_ts                                DATETIMEOFFSET DEFAULT(GETDATE()),
    deleted                                    bit DEFAULT(0)
);

CREATE TABLE sales.cashier_login_info
(
    cashier_login_info_id                   uniqueidentifier PRIMARY KEY DEFAULT(NEWID()),
    counter_id                              integer REFERENCES inventory.counters,
    cashier_id                              integer REFERENCES sales.cashiers,
    login_date                              DATETIMEOFFSET NOT NULL,
    success                                 bit NOT NULL,
    attempted_by                            integer NOT NULL REFERENCES account.users,
    browser                                 national character varying(1000),
    ip_address                              national character varying(1000),
    user_agent                              national character varying(1000),    
    audit_user_id                           integer REFERENCES account.users,
    audit_ts                                DATETIMEOFFSET DEFAULT(GETDATE()),
    deleted                                    bit DEFAULT(0)
);



CREATE TABLE sales.quotations
(
    quotation_id                            bigint IDENTITY PRIMARY KEY,
    value_date                              date NOT NULL,
    expected_delivery_date                    date NOT NULL,
    transaction_timestamp                   DATETIMEOFFSET NOT NULL DEFAULT(GETDATE()),
    customer_id                             integer NOT NULL REFERENCES inventory.customers,
    price_type_id                           integer NOT NULL REFERENCES sales.price_types,
    shipper_id                                integer REFERENCES inventory.shippers,
    user_id                                 integer NOT NULL REFERENCES account.users,
    office_id                               integer NOT NULL REFERENCES core.offices,
    reference_number                        national character varying(24),
    terms                                    national character varying(500),
    internal_memo                           national character varying(500),
    audit_user_id                           integer REFERENCES account.users,
    audit_ts                                DATETIMEOFFSET DEFAULT(GETDATE()),
    deleted                                    bit DEFAULT(0)
);

CREATE TABLE sales.quotation_details
(
    quotation_detail_id                     bigint IDENTITY PRIMARY KEY,
    quotation_id                            bigint NOT NULL REFERENCES sales.quotations,
    value_date                              date NOT NULL,
    item_id                                 integer NOT NULL REFERENCES inventory.items,
    price                                   decimal(30, 6) NOT NULL,
    discount_rate                           decimal(30, 6) NOT NULL DEFAULT(0),    
    tax                                     decimal(30, 6) NOT NULL DEFAULT(0),    
    shipping_charge                         decimal(30, 6) NOT NULL DEFAULT(0),    
    unit_id                                 integer NOT NULL REFERENCES inventory.units,
    quantity                                decimal(30, 6) NOT NULL
);


CREATE TABLE sales.orders
(
    order_id                                bigint IDENTITY PRIMARY KEY,
    quotation_id                            bigint REFERENCES sales.quotations,
    value_date                              date NOT NULL,
    expected_delivery_date                    date NOT NULL,
    transaction_timestamp                   DATETIMEOFFSET NOT NULL DEFAULT(GETDATE()),
    customer_id                             integer NOT NULL REFERENCES inventory.customers,
    price_type_id                           integer NOT NULL REFERENCES sales.price_types,
    shipper_id                                integer REFERENCES inventory.shippers,
    user_id                                 integer NOT NULL REFERENCES account.users,
    office_id                               integer NOT NULL REFERENCES core.offices,
    reference_number                        national character varying(24),
    terms                                   national character varying(500),
    internal_memo                           national character varying(500),
    audit_user_id                           integer REFERENCES account.users,
    audit_ts                                DATETIMEOFFSET DEFAULT(GETDATE()),
    deleted                                    bit DEFAULT(0)
);

CREATE TABLE sales.order_details
(
    order_detail_id                         bigint IDENTITY PRIMARY KEY,
    order_id                                bigint NOT NULL REFERENCES sales.orders,
    value_date                              date NOT NULL,
    item_id                                 integer NOT NULL REFERENCES inventory.items,
    price                                   decimal(30, 6) NOT NULL,
    discount_rate                           decimal(30, 6) NOT NULL DEFAULT(0),    
    tax                                     decimal(30, 6) NOT NULL DEFAULT(0),    
    shipping_charge                         decimal(30, 6) NOT NULL DEFAULT(0),    
    unit_id                                 integer NOT NULL REFERENCES inventory.units,
    quantity                                decimal(30, 6) NOT NULL
);


CREATE TABLE sales.coupons
(
    coupon_id                                   integer IDENTITY PRIMARY KEY,
    coupon_name                                 national character varying(100) NOT NULL,
    coupon_code                                 national character varying(100) NOT NULL,
    discount_rate                               decimal(30, 6) NOT NULL,
    is_percentage                               bit NOT NULL DEFAULT(0),
    maximum_discount_amount                     decimal(30, 6),
    associated_price_type_id                    integer REFERENCES sales.price_types,
    minimum_purchase_amount                     decimal(30, 6),
    maximum_purchase_amount                     decimal(30, 6),
    begins_from                                 date,
    expires_on                                  date,
    maximum_usage                               integer,
    enable_ticket_printing                      bit,
    for_ticket_of_price_type_id                 integer REFERENCES sales.price_types,
    for_ticket_having_minimum_amount            decimal(30, 6),
    for_ticket_having_maximum_amount            decimal(30, 6),
    for_ticket_of_unknown_customers_only        bit,
    audit_user_id                               integer REFERENCES account.users,
    audit_ts                                    DATETIMEOFFSET DEFAULT(GETDATE()),
    deleted                                        bit DEFAULT(0)    
);

CREATE UNIQUE INDEX coupons_coupon_code_uix
ON sales.coupons(coupon_code);



CREATE TABLE sales.sales
(
    sales_id                                bigint IDENTITY PRIMARY KEY,
    invoice_number                            bigint NOT NULL,
    fiscal_year_code                        national character varying(12) NOT NULL REFERENCES finance.fiscal_year,
    cash_repository_id                        integer REFERENCES finance.cash_repositories,
    price_type_id                            integer NOT NULL REFERENCES sales.price_types,
    sales_order_id                            bigint REFERENCES sales.orders,
    sales_quotation_id                        bigint REFERENCES sales.quotations,
    transaction_master_id                    bigint NOT NULL REFERENCES finance.transaction_master,
    checkout_id                             bigint NOT NULL REFERENCES inventory.checkouts,
    counter_id                              integer NOT NULL REFERENCES inventory.counters,
    customer_id                             integer REFERENCES inventory.customers,
    salesperson_id                            integer REFERENCES account.users,
    total_amount                            decimal(30, 6) NOT NULL,
    coupon_id                                integer REFERENCES sales.coupons,
    is_flat_discount                        bit,
    discount                                decimal(30, 6),
    total_discount_amount                    decimal(30, 6),    
    is_credit                               bit NOT NULL DEFAULT(0),
    credit_settled                            bit,
    payment_term_id                         integer REFERENCES sales.payment_terms,
    tender                                  numeric(30, 6) NOT NULL,
    change                                  numeric(30, 6) NOT NULL,
    gift_card_id                            integer REFERENCES sales.gift_cards,
    check_number                            national character varying(100),
    check_date                              date,
    check_bank_name                         national character varying(1000),
    check_amount                            decimal(30, 6),
    check_cleared                           bit,    
    check_clear_date                        date,   
    check_clearing_memo                     national character varying(1000),
    check_clearing_transaction_master_id    bigint REFERENCES finance.transaction_master,
    reward_points                            numeric(30, 6) NOT NULL DEFAULT(0)
);

CREATE UNIQUE INDEX sales_invoice_number_fiscal_year_uix
ON sales.sales(fiscal_year_code, invoice_number);


CREATE TABLE sales.customer_receipts
(
    receipt_id                              bigint IDENTITY PRIMARY KEY,
    transaction_master_id                   bigint NOT NULL REFERENCES finance.transaction_master,
    customer_id                             integer NOT NULL REFERENCES inventory.customers,
    currency_code                           national character varying(12) NOT NULL REFERENCES core.currencies,
    er_debit                                decimal(30, 6) NOT NULL,
    er_credit                               decimal(30, 6) NOT NULL,
    cash_repository_id                      integer NULL REFERENCES finance.cash_repositories,
    posted_date                             date NULL,
    tender                                  decimal(30, 6),
    change                                  decimal(30, 6),
    check_amount                            decimal(30, 6),
    bank_name                               national character varying(1000),
    check_number                            national character varying(100),
    check_date                              date,
    gift_card_number                        national character varying(100)
);

CREATE INDEX customer_receipts_transaction_master_id_inx
ON sales.customer_receipts(transaction_master_id);

CREATE INDEX customer_receipts_customer_id_inx
ON sales.customer_receipts(customer_id);

CREATE INDEX customer_receipts_currency_code_inx
ON sales.customer_receipts(currency_code);

CREATE INDEX customer_receipts_cash_repository_id_inx
ON sales.customer_receipts(cash_repository_id);

CREATE INDEX customer_receipts_posted_date_inx
ON sales.customer_receipts(posted_date);



CREATE TABLE sales.returns
(
    return_id                               bigint IDENTITY PRIMARY KEY,
    sales_id                                bigint NOT NULL REFERENCES sales.sales,
    checkout_id                             bigint NOT NULL REFERENCES inventory.checkouts,
    transaction_master_id                    bigint NOT NULL REFERENCES finance.transaction_master,
    return_transaction_master_id            bigint NOT NULL REFERENCES finance.transaction_master,
    counter_id                              integer NOT NULL REFERENCES inventory.counters,
    customer_id                             integer REFERENCES inventory.customers,
    price_type_id                            integer NOT NULL REFERENCES sales.price_types,
    is_credit                                bit
);


CREATE TABLE sales.opening_cash
(
    opening_cash_id                            bigint IDENTITY PRIMARY KEY,
    user_id                                    integer NOT NULL REFERENCES account.users,
    transaction_date                        date NOT NULL,
    amount                                    numeric(30, 6) NOT NULL,
    provided_by                                national character varying(1000) NOT NULL DEFAULT(''),
    memo                                    national character varying(4000) DEFAULT(''),
    closed                                    bit NOT NULL DEFAULT(0),
    audit_user_id                           integer REFERENCES account.users,
    audit_ts                                DATETIMEOFFSET NULL DEFAULT(GETDATE()),
    deleted                                    bit DEFAULT(0)
);

CREATE UNIQUE INDEX opening_cash_transaction_date_user_id_uix
ON sales.opening_cash(user_id, transaction_date);

CREATE TABLE sales.closing_cash
(
    closing_cash_id                            bigint IDENTITY PRIMARY KEY,
    user_id                                    integer NOT NULL REFERENCES account.users,
    transaction_date                        date NOT NULL,
    opening_cash                            numeric(30, 6) NOT NULL,
    total_cash_sales                        numeric(30, 6) NOT NULL,
    submitted_to                            national character varying(1000) NOT NULL DEFAULT(''),
    memo                                    national character varying(4000) NOT NULL DEFAULT(''),
    deno1000                                integer DEFAULT(0),
    deno500                                    integer DEFAULT(0),
    deno250                                    integer DEFAULT(0),
    deno200                                    integer DEFAULT(0),
    deno100                                    integer DEFAULT(0),
    deno50                                    integer DEFAULT(0),
    deno25                                    integer DEFAULT(0),
    deno20                                    integer DEFAULT(0),
    deno10                                    integer DEFAULT(0),
    deno5                                    integer DEFAULT(0),
    deno2                                    integer DEFAULT(0),
    deno1                                    integer DEFAULT(0),
    coins                                    numeric(30, 6) DEFAULT(0),
    submitted_cash                            numeric(30, 6) NOT NULL,
    approved_by                                integer REFERENCES account.users,
    approval_memo                            national character varying(4000),
    audit_user_id                           integer REFERENCES account.users,
    audit_ts                                DATETIMEOFFSET NULL DEFAULT(GETDATE()),
    deleted                                    bit DEFAULT(0)
);

CREATE UNIQUE INDEX closing_cash_transaction_date_user_id_uix
ON sales.closing_cash(user_id, transaction_date);


CREATE TYPE sales.sales_detail_type
AS TABLE
(
    store_id            integer,
    transaction_type    national character varying(2),
    item_id               integer,
    quantity            decimal(30, 6),
    unit_id               integer,
    price               decimal(30, 6),
    discount_rate       decimal(30, 6),
    tax                 decimal(30, 6),
    shipping_charge     decimal(30, 6)
);




GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.add_gift_card_fund.sql --<--<--
IF OBJECT_ID('sales.add_gift_card_fund') IS NOT NULL
DROP PROCEDURE sales.add_gift_card_fund;

GO

CREATE PROCEDURE sales.add_gift_card_fund
(
    @user_id                                    integer, 
    @office_id                                  integer, 
    @login_id                                   bigint,
    @gift_card_id                               integer,
    @value_date                                 date,
    @book_date                                  date,
    @debit_account_id                           integer,
    @amount                                     decimal(30, 6),
    @cost_center_id                             integer,
    @reference_number                           national character varying(24), 
    @statement_reference                        national character varying(2000)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @transaction_master_id              bigint;
    DECLARE @book_name                          national character varying(50) = 'Gift Card Fund Sales';
    DECLARE @payable_account_id                 integer;
    DECLARE @currency_code                      national character varying(12);

    SET @currency_code                              = core.get_currency_code_by_office_id(@office_id);
    SET @payable_account_id                         = sales.get_payable_account_id_by_gift_card_id(@gift_card_id);

    INSERT INTO finance.transaction_master(transaction_counter, transaction_code, book, value_date, book_date, login_id, user_id, office_id, cost_center_id, reference_number, statement_reference)
    SELECT
        finance.get_new_transaction_counter(@value_date),
        finance.get_transaction_code(@value_date, @office_id, @user_id, @login_id),
        @book_name,
        @value_date,
        @book_date,
        @login_id,
        @user_id,
        @office_id,
        @cost_center_id,
        @reference_number,
        @statement_reference;

    SET @transaction_master_id = SCOPE_IDENTITY();

    INSERT INTO finance.transaction_details(transaction_master_id, value_date, book_date, tran_type, account_id, statement_reference, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency, office_id, audit_user_id)
    SELECT
        @transaction_master_id, 
        @value_date, 
        @book_date,
        'Cr', 
        @payable_account_id, 
        @statement_reference, 
        @currency_code, 
        @amount, 
        @currency_code, 
        1, 
        @amount, 
        @office_id, 
        @user_id;

    INSERT INTO finance.transaction_details(transaction_master_id, value_date, book_date, tran_type, account_id, statement_reference, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency, office_id, audit_user_id)
    SELECT
        @transaction_master_id, 
        @value_date, 
        @book_date,
        'Dr', 
        @debit_account_id, 
        @statement_reference, 
        @currency_code, 
        @amount, 
        @currency_code, 
        1, 
        @amount, 
        @office_id, 
        @user_id;

    INSERT INTO sales.gift_card_transactions(gift_card_id, value_date, book_date, transaction_master_id, transaction_type, amount)
    SELECT @gift_card_id, @value_date, @book_date, @transaction_master_id, 'Cr', @amount;

    SELECT @transaction_master_id;
END;



--SELECT * FROM sales.add_gift_card_fund(1, 1, 1, sales.get_gift_card_id_by_gift_card_number('123456'), '1-1-2020', '1-1-2020', 1, 2000, 1, '', '');



GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.add_opening_cash.sql --<--<--
IF OBJECT_ID('sales.add_opening_cash') IS NOT NULL
DROP PROCEDURE sales.add_opening_cash;

GO

CREATE PROCEDURE sales.add_opening_cash
(
    @user_id                                integer,
    @transaction_date                       DATETIMEOFFSET,
    @amount                                 numeric(30, 6),
    @provided_by                            national character varying(1000),
    @memo                                   national character varying(4000)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM sales.opening_cash
        WHERE user_id = @user_id
        AND transaction_date = @transaction_date
    )
    BEGIN
        INSERT INTO sales.opening_cash(user_id, transaction_date, amount, provided_by, memo, audit_user_id, audit_ts, deleted)
        SELECT @user_id, @transaction_date, @amount, @provided_by, @memo, @user_id, GETDATE(), 0;
    END
    ELSE
    BEGIN
        UPDATE sales.opening_cash
        SET
            amount = @amount,
            provided_by = @provided_by,
            memo = @memo,
            user_id = @user_id,
            audit_user_id = @user_id,
            audit_ts = GETDATE(),
            deleted = 0
        WHERE user_id = @user_id
        AND transaction_date = @transaction_date;
    END;
END



GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.get_active_coupon_id_by_coupon_code.sql --<--<--
IF OBJECT_ID('sales.get_active_coupon_id_by_coupon_code') IS NOT NULL
DROP FUNCTION sales.get_active_coupon_id_by_coupon_code;

GO

CREATE FUNCTION sales.get_active_coupon_id_by_coupon_code(@coupon_code national character varying(100))
RETURNS integer
AS

BEGIN
    RETURN
    (
	    SELECT sales.coupons.coupon_id
	    FROM sales.coupons
	    WHERE sales.coupons.coupon_code = @coupon_code
	    AND COALESCE(sales.coupons.begins_from, CAST(GETDATE() AS date)) >= CAST(GETDATE() AS date)
	    AND COALESCE(sales.coupons.expires_on, CAST(GETDATE() AS date)) <= CAST(GETDATE() AS date)
	    AND sales.coupons.deleted = 0
    );
END;




GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.get_avaiable_coupons_to_print.sql --<--<--
IF OBJECT_ID('sales.get_avaiable_coupons_to_print') IS NOT NULL
DROP FUNCTION sales.get_avaiable_coupons_to_print;

GO

CREATE FUNCTION sales.get_avaiable_coupons_to_print(@tran_id bigint)
RETURNS @result TABLE
(
    coupon_id               integer
)
AS
BEGIN
    DECLARE @price_type_id                  integer;
    DECLARE @total_amount                   decimal(30, 6);
    DECLARE @customer_id                    integer;

    DECLARE @temp_coupons TABLE
    (
        coupon_id                           integer,
        maximum_usage                       integer,
        total_used                          integer
    );
    
    SELECT
        @price_type_id = sales.sales.price_type_id,
        @total_amount = sales.sales.total_amount,
        @customer_id = sales.sales.customer_id        
    FROM sales.sales
    WHERE sales.sales.transaction_master_id = @tran_id;


    INSERT INTO @temp_coupons(coupon_id, maximum_usage)
    SELECT sales.coupons.coupon_id, sales.coupons.maximum_usage
    FROM sales.coupons
    WHERE sales.coupons.deleted = 0
    AND sales.coupons.enable_ticket_printing = 1
    AND (sales.coupons.begins_from IS NULL OR sales.coupons.begins_from >= CAST(GETDATE() AS date))
    AND (sales.coupons.expires_on IS NULL OR sales.coupons.expires_on <= CAST(GETDATE() AS date))
    AND sales.coupons.for_ticket_of_price_type_id IS NULL
    AND COALESCE(sales.coupons.for_ticket_having_minimum_amount, 0) = 0
    AND COALESCE(sales.coupons.for_ticket_having_maximum_amount, 0) = 0
    AND sales.coupons.for_ticket_of_unknown_customers_only IS NULL;

    INSERT INTO @temp_coupons(coupon_id, maximum_usage)
    SELECT sales.coupons.coupon_id, sales.coupons.maximum_usage
    FROM sales.coupons
    WHERE sales.coupons.deleted = 0
    AND sales.coupons.enable_ticket_printing = 1
    AND (sales.coupons.begins_from IS NULL OR sales.coupons.begins_from >= CAST(GETDATE() AS date))
    AND (sales.coupons.expires_on IS NULL OR sales.coupons.expires_on <= CAST(GETDATE() AS date))
    AND (sales.coupons.for_ticket_of_price_type_id IS NULL OR for_ticket_of_price_type_id = @price_type_id)
    AND (sales.coupons.for_ticket_having_minimum_amount IS NULL OR sales.coupons.for_ticket_having_minimum_amount <= @total_amount)
    AND (sales.coupons.for_ticket_having_maximum_amount IS NULL OR sales.coupons.for_ticket_having_maximum_amount >= @total_amount)
    AND sales.coupons.for_ticket_of_unknown_customers_only IS NULL;

    IF(COALESCE(@customer_id, 0) > 0)
    BEGIN
        INSERT INTO @temp_coupons(coupon_id, maximum_usage)
        SELECT sales.coupons.coupon_id, sales.coupons.maximum_usage
        FROM sales.coupons
        WHERE sales.coupons.deleted = 0
        AND sales.coupons.enable_ticket_printing = 1
        AND (sales.coupons.begins_from IS NULL OR sales.coupons.begins_from >= CAST(GETDATE() AS date))
        AND (sales.coupons.expires_on IS NULL OR sales.coupons.expires_on <= CAST(GETDATE() AS date))
        AND (sales.coupons.for_ticket_of_price_type_id IS NULL OR for_ticket_of_price_type_id = @price_type_id)
        AND (sales.coupons.for_ticket_having_minimum_amount IS NULL OR sales.coupons.for_ticket_having_minimum_amount <= @total_amount)
        AND (sales.coupons.for_ticket_having_maximum_amount IS NULL OR sales.coupons.for_ticket_having_maximum_amount >= @total_amount)
        AND sales.coupons.for_ticket_of_unknown_customers_only = 0;
    END
    ELSE
    BEGIN
        INSERT INTO @temp_coupons(coupon_id, maximum_usage)
        SELECT sales.coupons.coupon_id, sales.coupons.maximum_usage
        FROM sales.coupons
        WHERE sales.coupons.deleted = 0
        AND sales.coupons.enable_ticket_printing = 1
        AND (sales.coupons.begins_from IS NULL OR sales.coupons.begins_from >= CAST(GETDATE() AS date))
        AND (sales.coupons.expires_on IS NULL OR sales.coupons.expires_on <= CAST(GETDATE() AS date))
        AND (sales.coupons.for_ticket_of_price_type_id IS NULL OR for_ticket_of_price_type_id = @price_type_id)
        AND (sales.coupons.for_ticket_having_minimum_amount IS NULL OR sales.coupons.for_ticket_having_minimum_amount <= @total_amount)
        AND (sales.coupons.for_ticket_having_maximum_amount IS NULL OR sales.coupons.for_ticket_having_maximum_amount >= @total_amount)
        AND sales.coupons.for_ticket_of_unknown_customers_only = 1;    
    END;

    UPDATE @temp_coupons
    SET total_used = 
    (
        SELECT COUNT(*)
        FROM sales.sales
        WHERE sales.sales.coupon_id = coupon_id 
    );

    DELETE FROM @temp_coupons WHERE total_used > maximum_usage;
    
    INSERT INTO @result
    SELECT coupon_id FROM @temp_coupons;

    RETURN;
END;



--SELECT * FROM sales.get_avaiable_coupons_to_print(2);

GO

-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.get_gift_card_balance.sql --<--<--
IF OBJECT_ID('sales.get_gift_card_balance') IS NOT NULL
DROP FUNCTION sales.get_gift_card_balance;

GO

CREATE FUNCTION sales.get_gift_card_balance(@gift_card_id integer, @value_date date)
RETURNS numeric(30, 6)
AS
BEGIN
    DECLARE @debit          numeric(30, 6);
    DECLARE @credit         numeric(30, 6);

    SELECT @debit = SUM(COALESCE(sales.gift_card_transactions.amount, 0))
    FROM sales.gift_card_transactions
    INNER JOIN finance.transaction_master
    ON finance.transaction_master.transaction_master_id = sales.gift_card_transactions.transaction_master_id
    WHERE finance.transaction_master.verification_status_id > 0
    AND sales.gift_card_transactions.transaction_type = 'Dr'
    AND finance.transaction_master.value_date <= @value_date;

    SELECT @credit = SUM(COALESCE(sales.gift_card_transactions.amount, 0))
    FROM sales.gift_card_transactions
    INNER JOIN finance.transaction_master
    ON finance.transaction_master.transaction_master_id = sales.gift_card_transactions.transaction_master_id
    WHERE finance.transaction_master.verification_status_id > 0
    AND sales.gift_card_transactions.transaction_type = 'Cr'
    AND finance.transaction_master.value_date <= @value_date;

    --Gift cards are account payables
    RETURN COALESCE(@credit, 0) - COALESCE(@debit, 0);
END



GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.get_gift_card_id_by_gift_card_number.sql --<--<--
IF OBJECT_ID('sales.get_gift_card_id_by_gift_card_number') IS NOT NULL
DROP FUNCTION sales.get_gift_card_id_by_gift_card_number;

GO

CREATE FUNCTION sales.get_gift_card_id_by_gift_card_number(@gift_card_number national character varying(100))
RETURNS integer
AS

BEGIN
    RETURN
    (
	    SELECT sales.gift_cards.gift_card_id
	    FROM sales.gift_cards
	    WHERE sales.gift_cards.gift_card_number = @gift_card_number
	    AND sales.gift_cards.deleted = 0
    );
END;





GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.get_item_selling_price.sql --<--<--
IF OBJECT_ID('sales.get_item_selling_price') IS NOT NULL
DROP FUNCTION sales.get_item_selling_price;

GO

CREATE FUNCTION sales.get_item_selling_price(@item_id integer, @customer_type_id integer, @price_type_id integer, @unit_id integer)
RETURNS decimal(30, 6)
AS
BEGIN
    DECLARE @price              decimal(30, 6);
    DECLARE @costing_unit_id    integer;
    DECLARE @factor             decimal(30, 6);
    DECLARE @tax_rate           decimal(30, 6);
    DECLARE @includes_tax       bit;
    DECLARE @tax                decimal(30, 6);

    --Fist pick the catalog price which matches all these fields:
    --Item, Customer Type, Price Type, and Unit.
    --This is the most effective price.
    SELECT 
        @price              = item_selling_prices.price, 
        @costing_unit_id    = item_selling_prices.unit_id,
        @includes_tax       = item_selling_prices.includes_tax
    FROM sales.item_selling_prices
    WHERE item_selling_prices.item_id=@item_id
    AND item_selling_prices.customer_type_id=@customer_type_id
    AND item_selling_prices.price_type_id =@price_type_id
    AND item_selling_prices.unit_id = @unit_id
    AND sales.item_selling_prices.deleted = 0;

    IF(@costing_unit_id IS NULL)
    BEGIN
        --We do not have a selling price of this item for the unit supplied.
        --Let's see if this item has a price for other units.
        SELECT 
            @price              = item_selling_prices.price, 
            @costing_unit_id    = item_selling_prices.unit_id,
            @includes_tax       = item_selling_prices.includes_tax
        FROM sales.item_selling_prices
        WHERE item_selling_prices.item_id=@item_id
        AND item_selling_prices.customer_type_id=@customer_type_id
        AND item_selling_prices.price_type_id =@price_type_id
        AND sales.item_selling_prices.deleted = 0;
    END;

    IF(@price IS NULL)
    BEGIN
        SELECT 
            @price              = item_selling_prices.price, 
            @costing_unit_id    = item_selling_prices.unit_id,
            @includes_tax       = item_selling_prices.includes_tax
        FROM sales.item_selling_prices
        WHERE item_selling_prices.item_id=@item_id
        AND item_selling_prices.price_type_id =@price_type_id
        AND sales.item_selling_prices.deleted = 0;
    END;

    
    IF(@price IS NULL)
    BEGIN
        --This item does not have selling price defined in the catalog.
        --Therefore, getting the default selling price from the item definition.
        SELECT 
            @price              = selling_price, 
            @costing_unit_id    = unit_id,
            @includes_tax       = 0
        FROM inventory.items
        WHERE inventory.items.item_id = @item_id
        AND inventory.items.deleted = 0;
    END;

    IF(@includes_tax = 1)
    BEGIN
        SET @tax_rate = core.get_item_tax_rate(@item_id);
        SET @price = @price / ((100 + @tax_rate)/ 100);
    END;

    --Get the unitary conversion factor if the requested unit does not match with the price defition.
    SET @factor = inventory.convert_unit(@unit_id, @costing_unit_id);

    RETURN @price * @factor;
END;

GO



-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.get_late_fee_id_by_late_fee_code.sql --<--<--
IF OBJECT_ID('sales.get_late_fee_id_by_late_fee_code') IS NOT NULL
DROP FUNCTION sales.get_late_fee_id_by_late_fee_code;

GO

CREATE FUNCTION sales.get_late_fee_id_by_late_fee_code(@late_fee_code national character varying(24))
RETURNS integer
AS

BEGIN
    RETURN
    (
	    SELECT sales.late_fee.late_fee_id
	    FROM sales.late_fee
	    WHERE sales.late_fee.late_fee_code = @late_fee_code
	    AND sales.late_fee.deleted = 0
    );
END;




GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.get_order_view.sql --<--<--
IF OBJECT_ID('sales.get_order_view') IS NOT NULL
DROP FUNCTION sales.get_order_view;

GO


CREATE FUNCTION sales.get_order_view
(
    @user_id                        integer,
    @office_id                      integer,
    @customer                       national character varying(500),
    @from                           date,
    @to                             date,
    @expected_from                  date,
    @expected_to                    date,
    @id                             bigint,
    @reference_number               national character varying(500),
    @internal_memo                  national character varying(500),
    @terms                          national character varying(500),
    @posted_by                      national character varying(500),
    @office                         national character varying(500)
)
RETURNS @result TABLE
(
    id                              bigint,
    customer                        national character varying(500),
    value_date                      date,
    expected_date                   date,
    reference_number                national character varying(24),
    terms                           national character varying(500),
    internal_memo                   national character varying(500),
    posted_by                       national character varying(500),
    office                          national character varying(500),
    transaction_ts                  DATETIMEOFFSET
)
AS

BEGIN
    WITH office_cte(office_id) AS 
    (
        SELECT @office_id
        UNION ALL
        SELECT
            c.office_id
        FROM 
        office_cte AS p, 
        core.offices AS c 
        WHERE 
        parent_office_id = p.office_id
    )

    INSERT INTO @result
    SELECT 
        sales.orders.order_id,
        inventory.get_customer_name_by_customer_id(sales.orders.customer_id),
        sales.orders.value_date,
        sales.orders.expected_delivery_date,
        sales.orders.reference_number,
        sales.orders.terms,
        sales.orders.internal_memo,
        account.get_name_by_user_id(sales.orders.user_id) AS posted_by,
        core.get_office_name_by_office_id(office_id) AS office,
        sales.orders.transaction_timestamp
    FROM sales.orders
    WHERE 1 = 1
    AND sales.orders.value_date BETWEEN @from AND @to
    AND sales.orders.expected_delivery_date BETWEEN @expected_from AND @expected_to
    AND sales.orders.office_id IN (SELECT office_id FROM office_cte)
    AND (COALESCE(@id, 0) = 0 OR @id = sales.orders.order_id)
    AND COALESCE(LOWER(sales.orders.reference_number), '') LIKE '%' + LOWER(@reference_number) + '%' 
    AND COALESCE(LOWER(sales.orders.internal_memo), '') LIKE '%' + LOWER(@internal_memo) + '%' 
    AND COALESCE(LOWER(sales.orders.terms), '') LIKE '%' + LOWER(@terms) + '%' 
    AND LOWER(inventory.get_customer_name_by_customer_id(sales.orders.customer_id)) LIKE '%' + LOWER(@customer) + '%' 
    AND LOWER(account.get_name_by_user_id(sales.orders.user_id)) LIKE '%' + LOWER(@posted_by) + '%' 
    AND LOWER(core.get_office_name_by_office_id(sales.orders.office_id)) LIKE '%' + LOWER(@office) + '%' 
    AND sales.orders.deleted = 0;

    RETURN;
END;




--SELECT * FROM sales.get_order_view(1,1, '', '11/27/2010','11/27/2016','1-1-2000','1-1-2020', null,'','','','', '');


GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.get_payable_account_for_gift_card.sql --<--<--
IF OBJECT_ID('sales.get_payable_account_for_gift_card') IS NOT NULL
DROP FUNCTION sales.get_payable_account_for_gift_card;

GO

CREATE FUNCTION sales.get_payable_account_for_gift_card(@gift_card_id integer)
RETURNS integer
AS

BEGIN
    RETURN
    (
	    SELECT sales.gift_cards.payable_account_id
	    FROM sales.gift_cards
	    WHERE sales.gift_cards.gift_card_id= @gift_card_id
	    AND sales.gift_cards.deleted = 0
    );
END;





GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.get_payable_account_id_by_gift_card_id.sql --<--<--
IF OBJECT_ID('sales.get_payable_account_id_by_gift_card_id') IS NOT NULL
DROP FUNCTION sales.get_payable_account_id_by_gift_card_id;

GO

CREATE FUNCTION sales.get_payable_account_id_by_gift_card_id(@gift_card_id integer)
RETURNS integer
AS

BEGIN
    RETURN
    (
	    SELECT sales.gift_cards.payable_account_id
	    FROM sales.gift_cards
	    WHERE sales.gift_cards.deleted = 0
	    AND sales.gift_cards.gift_card_id = @gift_card_id
   	);
END



GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.get_quotation_view.sql --<--<--
IF OBJECT_ID('sales.get_quotation_view') IS NOT NULL
DROP FUNCTION sales.get_quotation_view;

GO

CREATE FUNCTION sales.get_quotation_view
(
    @user_id                        integer,
    @office_id                      integer,
    @customer                       national character varying(500),
    @from                           date,
    @to                             date,
    @expected_from                  date,
    @expected_to                    date,
    @id                             bigint,
    @reference_number               national character varying(500),
    @internal_memo                  national character varying(500),
    @terms                          national character varying(500),
    @posted_by                      national character varying(500),
    @office                         national character varying(500)
)
RETURNS @result TABLE
(
    id                              bigint,
    customer                        national character varying(500),
    value_date                      date,
    expected_date                   date,
    reference_number                national character varying(24),
    terms                           national character varying(500),
    internal_memo                   national character varying(500),
    posted_by                       national character varying(500),
    office                          national character varying(500),
    transaction_ts                  DATETIMEOFFSET
)
AS

BEGIN
    WITH office_cte(office_id) AS 
    (
        SELECT @office_id
        UNION ALL
        SELECT
            c.office_id
        FROM 
        office_cte AS p, 
        core.offices AS c 
        WHERE 
        parent_office_id = p.office_id
    )

    INSERT INTO @result
    SELECT 
        sales.quotations.quotation_id,
        inventory.get_customer_name_by_customer_id(sales.quotations.customer_id),
        sales.quotations.value_date,
        sales.quotations.expected_delivery_date,
        sales.quotations.reference_number,
        sales.quotations.terms,
        sales.quotations.internal_memo,
        account.get_name_by_user_id(sales.quotations.user_id) AS posted_by,
        core.get_office_name_by_office_id(office_id) AS office,
        sales.quotations.transaction_timestamp
    FROM sales.quotations
    WHERE 1 = 1
    AND sales.quotations.value_date BETWEEN @from AND @to
    AND sales.quotations.expected_delivery_date BETWEEN @expected_from AND @expected_to
    AND sales.quotations.office_id IN (SELECT office_id FROM office_cte)
    AND (COALESCE(@id, 0) = 0 OR @id = sales.quotations.quotation_id)
    AND COALESCE(LOWER(sales.quotations.reference_number), '') LIKE '%' + LOWER(@reference_number) + '%' 
    AND COALESCE(LOWER(sales.quotations.internal_memo), '') LIKE '%' + LOWER(@internal_memo) + '%' 
    AND COALESCE(LOWER(sales.quotations.terms), '') LIKE '%' + LOWER(@terms) + '%' 
    AND LOWER(inventory.get_customer_name_by_customer_id(sales.quotations.customer_id)) LIKE '%' + LOWER(@customer) + '%' 
    AND LOWER(account.get_name_by_user_id(sales.quotations.user_id)) LIKE '%' + LOWER(@posted_by) + '%' 
    AND LOWER(core.get_office_name_by_office_id(sales.quotations.office_id)) LIKE '%' + LOWER(@office) + '%' 
    AND sales.quotations.deleted = 0;

    RETURN;
END;




--SELECT * FROM sales.get_quotation_view(1,1,'','11/27/2010','11/27/2016','1-1-2000','1-1-2020', null,'','','','', '');


GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.get_receivable_account_for_check_receipts.sql --<--<--
IF OBJECT_ID('sales.get_receivable_account_for_check_receipts') IS NOT NULL
DROP FUNCTION sales.get_receivable_account_for_check_receipts;

GO

CREATE FUNCTION sales.get_receivable_account_for_check_receipts(@store_id integer)
RETURNS integer
AS

BEGIN
    RETURN
    (
	    SELECT inventory.stores.default_account_id_for_checks
	    FROM inventory.stores
	    WHERE inventory.stores.store_id = @store_id
	    AND inventory.stores.deleted = 0
	);
END;





GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.post_cash_receipt.sql --<--<--
IF OBJECT_ID('sales.post_cash_receipt') IS NOT NULL
DROP PROCEDURE sales.post_cash_receipt;

GO

CREATE PROCEDURE sales.post_cash_receipt
(
    @user_id                                    integer, 
    @office_id                                  integer, 
    @login_id                                   bigint,
    @customer_id                                integer,
    @customer_account_id                        integer,
    @currency_code                              national character varying(12),
    @local_currency_code                        national character varying(12),
    @base_currency_code                         national character varying(12),
    @exchange_rate_debit                        decimal(30, 6), 
    @exchange_rate_credit                       decimal(30, 6),
    @reference_number                           national character varying(24), 
    @statement_reference                        national character varying(2000), 
    @cost_center_id                             integer,
    @cash_account_id                            integer,
    @cash_repository_id                         integer,
    @value_date                                 date,
    @book_date                                  date,
    @receivable                                 decimal(30, 6),
    @tender                                     decimal(30, 6),
    @change                                     decimal(30, 6),
    @cascading_tran_id                          bigint,
    @transaction_master_id                      bigint OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @book                               national character varying(50) = 'Sales Receipt';
    DECLARE @debit                              decimal(30, 6);
    DECLARE @credit                             decimal(30, 6);
    DECLARE @lc_debit                           decimal(30, 6);
    DECLARE @lc_credit                          decimal(30, 6);

    DECLARE @can_post_transaction           bit;
    DECLARE @error_message                  national character varying(MAX);

    SELECT
        @can_post_transaction   = can_post_transaction,
        @error_message          = error_message
    FROM finance.can_post_transaction(@login_id, @user_id, @office_id, @book, @value_date);

    IF(@can_post_transaction = 0)
    BEGIN
        RAISERROR(@error_message, 10, 1);
        RETURN;
    END;

    IF(@tender < @receivable)
    BEGIN
        RAISERROR('The tendered amount must be greater than or equal to sales amount', 10, 1);
    END;
    
    SET @debit                                  = @receivable;
    SET @lc_debit                               = @receivable * @exchange_rate_debit;

    SET @credit                                 = @receivable * (@exchange_rate_debit/ @exchange_rate_credit);
    SET @lc_credit                              = @receivable * @exchange_rate_debit;

    INSERT INTO finance.transaction_master
    (
        transaction_counter, 
        transaction_code, 
        book, 
        value_date, 
        book_date,
        user_id, 
        login_id, 
        office_id, 
        cost_center_id, 
        reference_number, 
        statement_reference,
        audit_user_id,
        cascading_tran_id
    )
    SELECT 
        finance.get_new_transaction_counter(@value_date), 
        finance.get_transaction_code(@value_date, @office_id, @user_id, @login_id),
        @book,
        @value_date,
        @book_date,
        @user_id,
        @login_id,
        @office_id,
        @cost_center_id,
        @reference_number,
        @statement_reference,
        @user_id,
        @cascading_tran_id;

    SET @transaction_master_id = SCOPE_IDENTITY();



    --Debit
    INSERT INTO finance.transaction_details(transaction_master_id, office_id, value_date, book_date, tran_type, account_id, statement_reference, cash_repository_id, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency, audit_user_id)
    SELECT @transaction_master_id, @office_id, @value_date, @book_date, 'Dr', @cash_account_id, @statement_reference, @cash_repository_id, @currency_code, @debit, @local_currency_code, @exchange_rate_debit, @lc_debit, @user_id;

    --Credit
    INSERT INTO finance.transaction_details(transaction_master_id, office_id, value_date,  book_date, tran_type, account_id, statement_reference, cash_repository_id, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency, audit_user_id)
    SELECT @transaction_master_id, @office_id, @value_date, @book_date, 'Cr', @customer_account_id, @statement_reference, NULL, @base_currency_code, @credit, @local_currency_code, @exchange_rate_credit, @lc_credit, @user_id;
    
    
    INSERT INTO sales.customer_receipts(transaction_master_id, customer_id, currency_code, er_debit, er_credit, cash_repository_id, posted_date, tender, change)
    SELECT @transaction_master_id, @customer_id, @currency_code, @exchange_rate_debit, @exchange_rate_credit, @cash_repository_id, @value_date, @tender, @change;

    SELECT @transaction_master_id;
END;



--SELECT * FROM sales.post_cash_receipt(1, 1, 1, 1, 1, 'USD', 'USD', 'USD', 1, 1, '', '', 1, 1, 1, '1-1-2020', '1-1-2020', 2000, 0, NULL);

GO

-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.post_check_receipt.sql --<--<--
IF OBJECT_ID('sales.post_check_receipt') IS NOT NULL
DROP PROCEDURE sales.post_check_receipt;

GO


CREATE PROCEDURE sales.post_check_receipt
(
    @user_id                                    integer, 
    @office_id                                  integer, 
    @login_id                                   bigint,
    @customer_id                                integer,
    @customer_account_id                        integer,
    @receivable_account_id                      integer,--sales.get_receivable_account_for_check_receipts(@store_id)
    @currency_code                              national character varying(12),
    @local_currency_code                        national character varying(12),
    @base_currency_code                         national character varying(12),
    @exchange_rate_debit                        decimal(30, 6), 
    @exchange_rate_credit                       decimal(30, 6),
    @reference_number                           national character varying(24), 
    @statement_reference                        national character varying(2000), 
    @cost_center_id                             integer,
    @value_date                                 date,
    @book_date                                  date,
    @check_amount                               decimal(30, 6),
    @check_bank_name                            national character varying(1000),
    @check_number                               national character varying(100),
    @check_date                                 date,
    @cascading_tran_id                          bigint,
    @transaction_master_id                      bigint OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @book                               national character varying(50) = 'Sales Receipt';
    DECLARE @debit                              decimal(30, 6);
    DECLARE @credit                             decimal(30, 6);
    DECLARE @lc_debit                           decimal(30, 6);
    DECLARE @lc_credit                          decimal(30, 6);

    DECLARE @can_post_transaction           bit;
    DECLARE @error_message                  national character varying(MAX);

    SELECT
        @can_post_transaction   = can_post_transaction,
        @error_message          = error_message
    FROM finance.can_post_transaction(@login_id, @user_id, @office_id, @book, @value_date);

    IF(@can_post_transaction = 0)
    BEGIN
        RAISERROR(@error_message, 10, 1);
        RETURN;
    END;

    SET @debit                                  = @check_amount;
    SET @lc_debit                               = @check_amount * @exchange_rate_debit;

    SET @credit                                 = @check_amount * (@exchange_rate_debit/ @exchange_rate_credit);
    SET @lc_credit                              = @check_amount * @exchange_rate_debit;
    
    INSERT INTO finance.transaction_master
    (
        transaction_counter, 
        transaction_code, 
        book, 
        value_date,
        book_date,
        user_id, 
        login_id, 
        office_id, 
        cost_center_id, 
        reference_number, 
        statement_reference,
        audit_user_id,
        cascading_tran_id
    )
    SELECT 
        finance.get_new_transaction_counter(@value_date), 
        finance.get_transaction_code(@value_date, @office_id, @user_id, @login_id),
        @book,
        @value_date,
        @book_date,
        @user_id,
        @login_id,
        @office_id,
        @cost_center_id,
        @reference_number,
        @statement_reference,
        @user_id,
        @cascading_tran_id;

    SET @transaction_master_id = SCOPE_IDENTITY();


    --Debit
    INSERT INTO finance.transaction_details(transaction_master_id, office_id, value_date, book_date, tran_type, account_id, statement_reference, cash_repository_id, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency, audit_user_id)
    SELECT @transaction_master_id, @office_id, @value_date, @book_date, 'Dr', @receivable_account_id, @statement_reference, NULL, @currency_code, @debit, @local_currency_code, @exchange_rate_debit, @lc_debit, @user_id;        

    --Credit
    INSERT INTO finance.transaction_details(transaction_master_id, office_id, value_date, book_date, tran_type, account_id, statement_reference, cash_repository_id, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency, audit_user_id)
    SELECT @transaction_master_id, @office_id, @value_date, @book_date, 'Cr', @customer_account_id, @statement_reference, NULL, @base_currency_code, @credit, @local_currency_code, @exchange_rate_credit, @lc_credit, @user_id;
    
    
    INSERT INTO sales.customer_receipts(transaction_master_id, customer_id, currency_code, er_debit, er_credit, posted_date, check_amount, bank_name, check_number, check_date)
    SELECT @transaction_master_id, @customer_id, @currency_code, @exchange_rate_debit, @exchange_rate_credit, @value_date, @check_amount, @check_bank_name, @check_number, @check_date;

    SELECT @transaction_master_id;
END;


GO

--SELECT * FROM sales.post_check_receipt(1, 1, 1, 1, 1, 1, 'USD', 'USD', 'USD', 1, 1, '', '', 1, '1-1-2020', '1-1-2020', 2000, '', '', '1-1-2020', null);


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.post_late_fee.sql --<--<--
IF OBJECT_ID('sales.post_late_fee') IS NOT NULL
DROP PROCEDURE sales.post_late_fee;

GO

CREATE PROCEDURE sales.post_late_fee(@user_id integer, @login_id bigint, @office_id integer, @value_date date)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @transaction_master_id          bigint;
    DECLARE @tran_counter                   integer;
    DECLARE @transaction_code               national character varying(50);
    DECLARE @default_currency_code          national character varying(12);
    DECLARE @book_name                      national character varying(100) = 'Late Fee';

    DECLARE @total_rows                     integer = 0;
    DECLARE @counter                        integer = 0;
    DECLARE @loop_transaction_master_id     bigint;
    DECLARE @loop_late_fee_name             national character varying(1000)
    DECLARE @loop_late_fee_account_id       integer;
    DECLARE @loop_customer_id               integer;
    DECLARE @loop_late_fee                  decimal(30, 6);
    DECLARE @loop_customer_account_id       integer;


    DECLARE @temp_late_fee TABLE
    (
        transaction_master_id               bigint,
        value_date                          date,
        payment_term_id                     integer,
        payment_term_code                   national character varying(50),
        payment_term_name                   national character varying(1000),        
        due_on_date                         bit,
        due_days                            integer,
        due_frequency_id                    integer,
        grace_period                        integer,
        late_fee_id                         integer,
        late_fee_posting_frequency_id       integer,
        late_fee_code                       national character varying(50),
        late_fee_name                       national character varying(1000),
        is_flat_amount                      bit,
        rate                                numeric(30, 6),
        due_amount                          decimal(30, 6),
        late_fee                            decimal(30, 6),
        customer_id                         bigint,
        customer_account_id                 integer,
        late_fee_account_id                 integer,
        due_date                            date
    ) ;

    WITH unpaid_invoices
    AS
    (
        SELECT 
             finance.transaction_master.transaction_master_id, 
             finance.transaction_master.value_date,
             sales.sales.payment_term_id,
             sales.payment_terms.payment_term_code,
             sales.payment_terms.payment_term_name,
             sales.payment_terms.due_on_date,
             sales.payment_terms.due_days,
             sales.payment_terms.due_frequency_id,
             sales.payment_terms.grace_period,
             sales.payment_terms.late_fee_id,
             sales.payment_terms.late_fee_posting_frequency_id,
             sales.late_fee.late_fee_code,
             sales.late_fee.late_fee_name,
             sales.late_fee.is_flat_amount,
             sales.late_fee.rate,
            0.00 as due_amount,
            0.00 as late_fee,
             sales.sales.customer_id,
            inventory.get_account_id_by_customer_id(sales.sales.customer_id) AS customer_account_id,
             sales.late_fee.account_id AS late_fee_account_id
        FROM  inventory.checkouts
        INNER JOIN sales.sales
        ON sales.sales.checkout_id = inventory.checkouts.checkout_id
        INNER JOIN  finance.transaction_master
        ON  finance.transaction_master.transaction_master_id =  inventory.checkouts.transaction_master_id
        INNER JOIN  sales.payment_terms
        ON  sales.payment_terms.payment_term_id =  sales.sales.payment_term_id
        INNER JOIN  sales.late_fee
        ON  sales.payment_terms.late_fee_id =  sales.late_fee.late_fee_id
        WHERE  finance.transaction_master.verification_status_id > 0
        AND  finance.transaction_master.book IN('Sales.Delivery', 'Sales.Direct')
        AND  sales.sales.is_credit = 1 AND  sales.sales.credit_settled = 0
        AND  sales.sales.payment_term_id IS NOT NULL
        AND  sales.payment_terms.late_fee_id IS NOT NULL
        AND  finance.transaction_master.transaction_master_id NOT IN
        (
            SELECT  sales.late_fee_postings.transaction_master_id        --We have already posted the late fee before.
            FROM  sales.late_fee_postings
        )
    ), 
    unpaid_invoices_details
    AS
    (
        SELECT *, 
        CASE WHEN unpaid_invoices.due_on_date = 1
        THEN DATEADD(day, unpaid_invoices.due_days + unpaid_invoices.grace_period, unpaid_invoices.value_date)
        ELSE DATEADD(day, unpaid_invoices.grace_period, finance.get_frequency_end_date(unpaid_invoices.due_frequency_id, unpaid_invoices.value_date)) END as due_date
        FROM unpaid_invoices
    )


    INSERT INTO @temp_late_fee
    SELECT * FROM unpaid_invoices_details
    WHERE unpaid_invoices_details.due_date <= @value_date;


    UPDATE @temp_late_fee
    SET due_amount = 
    (
        SELECT
            SUM
            (
                (inventory.checkout_details.quantity * inventory.checkout_details.price) 
                - 
                inventory.checkout_details.discount 
                + 
                inventory.checkout_details.tax
                + 
                inventory.checkout_details.shipping_charge
            )
        FROM inventory.checkout_details
        INNER JOIN  inventory.checkouts
        ON  inventory.checkouts. checkout_id = inventory.checkout_details. checkout_id
        WHERE  inventory.checkouts.transaction_master_id = transaction_master_id
    ) WHERE is_flat_amount = 0;

    UPDATE @temp_late_fee
    SET late_fee = rate
    WHERE is_flat_amount = 1;

    UPDATE @temp_late_fee
    SET late_fee = due_amount * rate / 100
    WHERE is_flat_amount = 0;

    SET @default_currency_code                  =  core.get_currency_code_by_office_id(@office_id);

    DELETE FROM @temp_late_fee
    WHERE late_fee <= 0
    AND customer_account_id IS NULL
    AND late_fee_account_id IS NULL;


    SELECT @total_rows=MAX(transaction_master_id) FROM @temp_late_fee;

    WHILE @counter<@total_rows
    BEGIN
        SELECT TOP 1 
            @loop_transaction_master_id = transaction_master_id,
            @loop_late_fee_name = late_fee_name,
            @loop_late_fee_account_id = late_fee_account_id,
            @loop_customer_id = customer_id,
            @loop_late_fee = late_fee,
            @loop_customer_account_id = customer_account_id
        FROM @temp_late_fee
        WHERE transaction_master_id >= @counter
        ORDER BY transaction_master_id;

        IF(@loop_transaction_master_id IS NOT NULL)
        BEGIN
            SET @counter = @loop_transaction_master_id + 1;        
        END
        ELSE
        BEGIN
            BREAK;
        END;

        SET @tran_counter           = finance.get_new_transaction_counter(@value_date);
        SET @transaction_code       = finance.get_transaction_code(@value_date, @office_id, @user_id, @login_id);

        INSERT INTO  finance.transaction_master
        (
            transaction_counter, 
            transaction_code, 
            book, 
            value_date, 
            user_id, 
            office_id, 
            reference_number,
            statement_reference,
            verification_status_id,
            verified_by_user_id,
            verification_reason
        ) 
        SELECT            
            @tran_counter, 
            @transaction_code, 
            @book_name, 
            @value_date, 
            @user_id, 
            @office_id,             
            CAST(@loop_transaction_master_id AS varchar(100)) AS reference_number,
            @loop_late_fee_name AS statement_reference,
            1,
            @user_id,
            'Automatically verified by workflow.';

        SET @transaction_master_id = SCOPE_IDENTITY();


        INSERT INTO  finance.transaction_details
        (
            transaction_master_id,
            value_date,
            tran_type, 
            account_id, 
            statement_reference, 
            currency_code, 
            amount_in_currency, 
            er, 
            local_currency_code, 
            amount_in_local_currency
        )
        SELECT
            @transaction_master_id,
            @value_date,
            'Cr',
            @loop_late_fee_account_id,
            @loop_late_fee_name + ' (' + core.get_customer_code_by_customer_id(@loop_customer_id) + ')',
            @default_currency_code, 
            @loop_late_fee, 
            1 AS exchange_rate,
            @default_currency_code,
            @loop_late_fee
        UNION ALL
        SELECT
            @transaction_master_id,
            @value_date,
            'Dr',
            @loop_customer_account_id,
            @loop_late_fee_name,
            @default_currency_code, 
            @loop_late_fee, 
            1 AS exchange_rate,
            @default_currency_code,
            @loop_late_fee;

        INSERT INTO  sales.late_fee_postings(transaction_master_id, customer_id, value_date, late_fee_tran_id, amount)
        SELECT @loop_transaction_master_id, @loop_customer_id, @value_date, @transaction_master_id, @loop_late_fee;
    END;
END;




--SELECT * FROM  sales.post_late_fee(2, 5, 2,  finance.get_value_date(2));

GO

EXECUTE finance.create_routine 'POST-LF', ' sales.post_late_fee', 250;

GO



-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.post_receipt.sql --<--<--
IF OBJECT_ID('sales.post_receipt') IS NOT NULL
DROP PROCEDURE sales.post_receipt;

GO

CREATE PROCEDURE sales.post_receipt
(
    @user_id                                    integer, 
    @office_id                                  integer, 
    @login_id                                   bigint,
    
    @customer_id                                integer,
    @currency_code                              national character varying(12), 
    @exchange_rate_debit                        decimal(30, 6), 

    @exchange_rate_credit                       decimal(30, 6),
    @reference_number                           national character varying(24), 
    @statement_reference                        national character varying(2000), 

    @cost_center_id                             integer,
    @cash_account_id                            integer,
    @cash_repository_id                         integer,

    @value_date                                 date,
    @book_date                                  date,
    @receipt_amount                             decimal(30, 6),

    @tender                                     decimal(30, 6),
    @change                                     decimal(30, 6),
    @check_amount                               decimal(30, 6),

    @check_bank_name                            national character varying(1000),
    @check_number                               national character varying(100),
    @check_date                                 date,

    @gift_card_number                           national character varying(100),
    @store_id                                   integer,
    @cascading_tran_id                          bigint
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @book                               national character varying(50);
    DECLARE @transaction_master_id              bigint;
    DECLARE @base_currency_code                 national character varying(12);
    DECLARE @local_currency_code                national character varying(12);
    DECLARE @customer_account_id                integer;
    DECLARE @debit                              decimal(30, 6);
    DECLARE @credit                             decimal(30, 6);
    DECLARE @lc_debit                           decimal(30, 6);
    DECLARE @lc_credit                          decimal(30, 6);
    DECLARE @is_cash                            bit;
    DECLARE @gift_card_id                       integer;
    DECLARE @receivable_account_id              integer;

    DECLARE @can_post_transaction           bit;
    DECLARE @error_message                  national character varying(MAX);

    SELECT
        @can_post_transaction   = can_post_transaction,
        @error_message          = error_message
    FROM finance.can_post_transaction(@login_id, @user_id, @office_id, @book, @value_date);

    IF(@can_post_transaction = 0)
    BEGIN
        RAISERROR(@error_message, 10, 1);
        RETURN;
    END;

    IF(@cash_repository_id > 0 AND @cash_account_id > 0)
    BEGIN
        SET @is_cash                            = 1;
    END;

    SET @receivable_account_id                  = sales.get_receivable_account_for_check_receipts(@store_id);
    SET @gift_card_id                           = sales.get_gift_card_id_by_gift_card_number(@gift_card_number);
    SET @customer_account_id                    = inventory.get_account_id_by_customer_id(@customer_id);    
    SET @local_currency_code                    = core.get_currency_code_by_office_id(@office_id);
    SET @base_currency_code                     = inventory.get_currency_code_by_customer_id(@customer_id);


    IF(@local_currency_code = @currency_code AND @exchange_rate_debit != 1)
    BEGIN
        RAISERROR('Invalid exchange rate.', 10, 1);
    END;

    IF(@base_currency_code = @currency_code AND @exchange_rate_credit != 1)
    BEGIN
        RAISERROR('Invalid exchange rate.', 10, 1);
    END;

    
    IF(@tender >= @receipt_amount)
    BEGIN
        EXECUTE sales.post_cash_receipt @user_id, @office_id, @login_id, @customer_id, @customer_account_id, @currency_code, @local_currency_code, @base_currency_code, @exchange_rate_debit, @exchange_rate_credit, @reference_number, @statement_reference, @cost_center_id, @cash_account_id, @cash_repository_id, @value_date, @book_date, @receipt_amount, @tender, @change, @cascading_tran_id,
        @transaction_master_id = @transaction_master_id OUTPUT;
    END
    ELSE IF(@check_amount >= @receipt_amount)
    BEGIN
        EXECUTE sales.post_check_receipt @user_id, @office_id, @login_id, @customer_id, @customer_account_id, @receivable_account_id, @currency_code, @local_currency_code, @base_currency_code, @exchange_rate_debit, @exchange_rate_credit, @reference_number, @statement_reference, @cost_center_id, @value_date, @book_date, @check_amount, @check_bank_name, @check_number, @check_date, @cascading_tran_id,
        @transaction_master_id = @transaction_master_id OUTPUT;
    END
    ELSE IF(@gift_card_id > 0)
    BEGIN
        EXECUTE sales.post_receipt_by_gift_card @user_id, @office_id, @login_id, @customer_id, @customer_account_id, @currency_code, @local_currency_code, @base_currency_code, @exchange_rate_debit, @exchange_rate_credit, @reference_number, @statement_reference, @cost_center_id, @value_date, @book_date, @gift_card_id, @gift_card_number, @receipt_amount, @cascading_tran_id,
        @transaction_master_id = @transaction_master_id OUTPUT;
    END
    ELSE
    BEGIN
        RAISERROR('Cannot post receipt. Please enter the tender amount.', 10, 1);
    END;

    
    EXECUTE finance.auto_verify @transaction_master_id, @office_id;

    EXECUTE sales.settle_customer_due @customer_id, @office_id;
    SELECT @transaction_master_id;
END;


GO



-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.post_receipt_by_gift_card.sql --<--<--
IF OBJECT_ID('sales.post_receipt_by_gift_card') IS NOT NULL
DROP PROCEDURE sales.post_receipt_by_gift_card;

GO

CREATE PROCEDURE sales.post_receipt_by_gift_card
(
    @user_id                                    integer, 
    @office_id                                  integer, 
    @login_id                                   bigint,
    @customer_id                                integer,
    @customer_account_id                        integer,
    @currency_code                              national character varying(12),
    @local_currency_code                        national character varying(12),
    @base_currency_code                         national character varying(12),
    @exchange_rate_debit                        decimal(30, 6), 
    @exchange_rate_credit                       decimal(30, 6),
    @reference_number                           national character varying(24), 
    @statement_reference                        national character varying(2000), 
    @cost_center_id                             integer,
    @value_date                                 date,
    @book_date                                  date,
    @gift_card_id                               integer,
    @gift_card_number                           national character varying(100),
    @amount                                     decimal(30, 6),
    @cascading_tran_id                          bigint,
    @transaction_master_id                      bigint OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @book                               national character varying(50) = 'Sales Receipt';
    DECLARE @debit                              decimal(30, 6);
    DECLARE @credit                             decimal(30, 6);
    DECLARE @lc_debit                           decimal(30, 6);
    DECLARE @lc_credit                          decimal(30, 6);
    DECLARE @is_cash                            bit;
    DECLARE @gift_card_payable_account_id       integer;

    DECLARE @can_post_transaction           bit;
    DECLARE @error_message                  national character varying(MAX);

    SELECT
        @can_post_transaction   = can_post_transaction,
        @error_message          = error_message
    FROM finance.can_post_transaction(@login_id, @user_id, @office_id, @book, @value_date);

    IF(@can_post_transaction = 0)
    BEGIN
        RAISERROR(@error_message, 10, 1);
        RETURN;
    END;

    SET @gift_card_payable_account_id           = sales.get_payable_account_for_gift_card(@gift_card_id);
    SET @debit                                  = @amount;
    SET @lc_debit                               = @amount * @exchange_rate_debit;

    SET @credit                                 = @amount * (@exchange_rate_debit/ @exchange_rate_credit);
    SET @lc_credit                              = @amount * @exchange_rate_debit;
    
    INSERT INTO finance.transaction_master
    (
        transaction_counter, 
        transaction_code, 
        book, 
        value_date, 
        book_date,
        user_id, 
        login_id, 
        office_id, 
        cost_center_id, 
        reference_number, 
        statement_reference,
        audit_user_id,
        cascading_tran_id
    )
    SELECT 
        finance.get_new_transaction_counter(@value_date), 
        finance.get_transaction_code(@value_date, @office_id, @user_id, @login_id),
        @book,
        @value_date,
        @book_date,
        @user_id,
        @login_id,
        @office_id,
        @cost_center_id,
        @reference_number,
        @statement_reference,
        @user_id,
        @cascading_tran_id;


    SET @transaction_master_id = SCOPE_IDENTITY();

    --Debit
    INSERT INTO finance.transaction_details(transaction_master_id, office_id, value_date, book_date, tran_type, account_id, statement_reference, cash_repository_id, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency, audit_user_id)
    SELECT @transaction_master_id, @office_id, @value_date, @book_date, 'Dr', @gift_card_payable_account_id, @statement_reference, NULL, @currency_code, @debit, @local_currency_code, @exchange_rate_debit, @lc_debit, @user_id;        

    --Credit
    INSERT INTO finance.transaction_details(transaction_master_id, office_id, value_date, book_date, tran_type, account_id, statement_reference, cash_repository_id, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency, audit_user_id)
    SELECT @transaction_master_id, @office_id, @value_date, @book_date, 'Cr', @customer_account_id, @statement_reference, NULL, @base_currency_code, @credit, @local_currency_code, @exchange_rate_credit, @lc_credit, @user_id;
    
    
    INSERT INTO sales.customer_receipts(transaction_master_id, customer_id, currency_code, er_debit, er_credit, posted_date, gift_card_number)
    SELECT @transaction_master_id, @customer_id, @currency_code, @exchange_rate_debit, @exchange_rate_credit, @value_date, @gift_card_number;

    SELECT @transaction_master_id;
END;



--select * from sales.post_receipt_by_gift_card(1,1, 1,1,1,'USD','USD','USD',1,1,'','',1,'1-1-2020', '1-1-2020', 1, '123456', 1000, NULL);

GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.post_return.sql --<--<--
IF OBJECT_ID('sales.post_return') IS NOT NULL
DROP PROCEDURE sales.post_return;

GO

CREATE PROCEDURE sales.post_return
(
    @transaction_master_id          bigint,
    @office_id                      integer,
    @user_id                        integer,
    @login_id                       bigint,
    @value_date                     date,
    @book_date                      date,
    @store_id                       integer,
    @counter_id                     integer,
    @customer_id                    integer,
    @price_type_id                  integer,
    @reference_number               national character varying(24),
    @statement_reference            national character varying(2000),
    @details                        sales.sales_detail_type READONLY,
    @tran_master_id                 bigint OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @book_name              national character varying = 'Sales Return';
    DECLARE @cost_center_id         bigint;
    DECLARE @tran_counter           integer;
    DECLARE @tran_code              national character varying(50);
    DECLARE @checkout_id            bigint;
    DECLARE @grand_total            decimal(30, 6);
    DECLARE @discount_total         decimal(30, 6);
    DECLARE @is_credit              bit;
    DECLARE @default_currency_code  national character varying(12);
    DECLARE @cost_of_goods_sold     decimal(30, 6);
    DECLARE @ck_id                  bigint;
    DECLARE @sales_id               bigint;
    DECLARE @tax_total              decimal(30, 6);
    DECLARE @tax_account_id         integer;


    DECLARE @can_post_transaction   bit;
    DECLARE @error_message          national character varying(MAX);

    SELECT
        @can_post_transaction   = can_post_transaction,
        @error_message          = error_message
    FROM finance.can_post_transaction(@login_id, @user_id, @office_id, @book_name, @value_date);

    IF(@can_post_transaction = 0)
    BEGIN
        RAISERROR(@error_message, 10, 1);
        RETURN;
    END;

    SET @tax_account_id                         = finance.get_sales_tax_account_id_by_office_id(@office_id);

    IF(sales.validate_items_for_return(@transaction_master_id, @details) = 0)
    BEGIN
        RETURN 0;
    END;

    SET @default_currency_code          = core.get_currency_code_by_office_id(@office_id);

    SELECT @sales_id = sales.sales.sales_id 
    FROM sales.sales
    WHERE sales.sales.transaction_master_id = +transaction_master_id;
    
    SELECT @cost_center_id = cost_center_id    
    FROM finance.transaction_master 
    WHERE finance.transaction_master.transaction_master_id = @transaction_master_id;

    SELECT 
        @is_credit  = is_credit,
        @ck_id      = checkout_id
    FROM sales.sales
    WHERE transaction_master_id = @transaction_master_id;

    DECLARE @checkout_details TABLE
    (
        id                              integer IDENTITY PRIMARY KEY,
        checkout_id                     bigint, 
        tran_type                       national character varying(2), 
        store_id                        integer,
        item_id                         integer, 
        quantity                        decimal(30, 6),        
        unit_id                         integer,
        base_quantity                   decimal(30, 6),
        base_unit_id                    integer,                
        price                           decimal(30, 6),
        cost_of_goods_sold              decimal(30, 6) DEFAULT(0),
        discount                        decimal(30, 6) DEFAULT(0),
        discount_rate                   decimal(30, 6),
        tax                             decimal(30, 6),
        shipping_charge                 decimal(30, 6),
        sales_account_id                integer,
        sales_discount_account_id       integer,
        sales_return_account_id         integer,
        inventory_account_id            integer,
        cost_of_goods_sold_account_id   integer
    ) ;
        
    INSERT INTO @checkout_details(store_id, item_id, quantity, unit_id, price, discount_rate, tax, shipping_charge)
    SELECT store_id, item_id, quantity, unit_id, price, discount_rate, tax, shipping_charge
    FROM @details;

    UPDATE @checkout_details 
    SET
        tran_type                   = 'Dr',
        base_quantity               = inventory.get_base_quantity_by_unit_id(unit_id, quantity),
        base_unit_id                = inventory.get_root_unit_id(unit_id);

    UPDATE @checkout_details
    SET
        sales_account_id                = inventory.get_sales_account_id(item_id),
        sales_discount_account_id       = inventory.get_sales_discount_account_id(item_id),
        sales_return_account_id         = inventory.get_sales_return_account_id(item_id),        
        inventory_account_id            = inventory.get_inventory_account_id(item_id),
        cost_of_goods_sold_account_id   = inventory.get_cost_of_goods_sold_account_id(item_id);
    
    IF EXISTS
    (
        SELECT TOP 1 0 FROM @checkout_details AS details
        WHERE inventory.is_valid_unit_id(details.unit_id, details.item_id) = 0
    )
    BEGIN
        RAISERROR('Item/unit mismatch.', 10, 1);
    END;


    SET @tran_counter               = finance.get_new_transaction_counter(@value_date);
    SET @tran_code                  = finance.get_transaction_code(@value_date, @office_id, @user_id, @login_id);

    INSERT INTO finance.transaction_master(transaction_counter, transaction_code, book, value_date, book_date, user_id, login_id, office_id, cost_center_id, reference_number, statement_reference)
    SELECT @tran_counter, @tran_code, @book_name, @value_date, @book_date, @user_id, @login_id, @office_id, @cost_center_id, @reference_number, @statement_reference;
    SET @tran_master_id = SCOPE_IDENTITY();
        
    SELECT @tax_total = SUM(COALESCE(tax, 0)) FROM @checkout_details;
    SELECT @discount_total = SUM(COALESCE(discount, 0)) FROM @checkout_details;
    SELECT @grand_total = SUM(COALESCE(price, 0) * COALESCE(quantity, 0)) FROM @checkout_details;



    UPDATE @checkout_details
    SET cost_of_goods_sold = COALESCE(inventory.get_write_off_cost_of_goods_sold(@ck_id, item_id, unit_id, quantity), 0);


    SELECT @cost_of_goods_sold = SUM(cost_of_goods_sold) FROM @checkout_details;


    IF(@cost_of_goods_sold > 0)
    BEGIN
        INSERT INTO finance.transaction_details(transaction_master_id, office_id, value_date, book_date, tran_type, account_id, statement_reference, currency_code, amount_in_currency, er, local_currency_code, amount_in_local_currency)
        SELECT @tran_master_id, @office_id, @value_date, @book_date, 'Dr', inventory_account_id, @statement_reference, @default_currency_code, SUM(COALESCE(cost_of_goods_sold, 0)), 1, @default_currency_code, SUM(COALESCE(cost_of_goods_sold, 0))
        FROM @checkout_details
        GROUP BY inventory_account_id;


        INSERT INTO finance.transaction_details(transaction_master_id, office_id, value_date, book_date, tran_type, account_id, statement_reference, currency_code, amount_in_currency, er, local_currency_code, amount_in_local_currency)
        SELECT @tran_master_id, @office_id, @value_date, @book_date, 'Cr', cost_of_goods_sold_account_id, @statement_reference, @default_currency_code, SUM(COALESCE(cost_of_goods_sold, 0)), 1, @default_currency_code, SUM(COALESCE(cost_of_goods_sold, 0))
        FROM @checkout_details
        GROUP BY cost_of_goods_sold_account_id;
    END;


    INSERT INTO finance.transaction_details(transaction_master_id, office_id, value_date, book_date, tran_type, account_id, statement_reference, currency_code, amount_in_currency, local_currency_code, er,amount_in_local_currency) 
    SELECT @tran_master_id, @office_id, @value_date, @book_date, 'Dr', sales_account_id, @statement_reference, @default_currency_code, SUM(COALESCE(price, 0) * COALESCE(quantity, 0)), @default_currency_code, 1, SUM(COALESCE(price, 0) * COALESCE(quantity, 0))
    FROM @checkout_details
    GROUP BY sales_account_id;


    IF(@discount_total IS NOT NULL AND @discount_total > 0)
    BEGIN
        INSERT INTO finance.transaction_details(office_id, value_date, book_date, tran_type, account_id, statement_reference, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency) 
        SELECT @office_id, @value_date, @book_date, 'Cr', sales_discount_account_id, @statement_reference, @default_currency_code, SUM(COALESCE(discount, 0)), @default_currency_code, 1, SUM(COALESCE(discount, 0))
        FROM @checkout_details
        GROUP BY sales_discount_account_id;

        SET @tran_master_id  = SCOPE_IDENTITY();
    END;

    IF(COALESCE(@tax_total, 0) > 0)
    BEGIN
        INSERT INTO finance.transaction_details(transaction_master_id, office_id, value_date, book_date, tran_type, account_id, statement_reference, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency) 
        SELECT @tran_master_id, @office_id, @value_date, @book_date, 'Dr', @tax_account_id, @statement_reference, @default_currency_code, @tax_total, @default_currency_code, 1, @tax_total;
    END;    

    IF(@is_credit = 1)
    BEGIN
        INSERT INTO finance.transaction_details(transaction_master_id, office_id, value_date, book_date, tran_type, account_id, statement_reference, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency) 
        SELECT @tran_master_id, @office_id, @value_date, @book_date, 'Cr',  inventory.get_account_id_by_customer_id(@customer_id), @statement_reference, @default_currency_code, @grand_total - @discount_total, @default_currency_code, 1, @grand_total - @discount_total;
    END
    ELSE
    BEGIN
        INSERT INTO finance.transaction_details(transaction_master_id, office_id, value_date, book_date, tran_type, account_id, statement_reference, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency) 
        SELECT @tran_master_id, @office_id, @value_date, @book_date, 'Cr',  sales_return_account_id, @statement_reference, @default_currency_code, SUM(COALESCE(price, 0) * COALESCE(quantity, 0)) - SUM(COALESCE(discount, 0)), @default_currency_code, 1, SUM(COALESCE(price, 0) * COALESCE(quantity, 0)) - SUM(COALESCE(discount, 0))
        FROM @checkout_details
        GROUP BY sales_return_account_id;
    END;



    INSERT INTO inventory.checkouts(transaction_book, value_date, book_date, transaction_master_id, office_id, posted_by) 
    SELECT @book_name, @value_date, @book_date, @tran_master_id, @office_id, @user_id;
    SET @checkout_id = SCOPE_IDENTITY();

    INSERT INTO inventory.checkout_details(value_date, book_date, checkout_id, transaction_type, store_id, item_id, quantity, unit_id, base_quantity, base_unit_id, price, tax, cost_of_goods_sold, discount)
    SELECT @value_date, @book_date, @checkout_id, tran_type, store_id, item_id, quantity, unit_id, base_quantity, base_unit_id, price, tax, cost_of_goods_sold, discount FROM @checkout_details;

    INSERT INTO sales.returns(sales_id, checkout_id, counter_id, transaction_master_id, return_transaction_master_id, customer_id, price_type_id, is_credit)
    SELECT @sales_id, @checkout_id, @counter_id, @transaction_master_id, @tran_master_id, @customer_id, @price_type_id, 0;

    EXECUTE finance.auto_verify @tran_master_id, @office_id;

    SELECT @tran_master_id;
END;

GO



-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.post_sales.sql --<--<--
IF OBJECT_ID('sales.post_sales') IS NOT NULL
DROP PROCEDURE sales.post_sales;

GO

CREATE PROCEDURE sales.post_sales
(
    @office_id                              integer,
    @user_id                                integer,
    @login_id                               bigint,
    @counter_id                             integer,
    @value_date                             date,
    @book_date                              date,
    @cost_center_id                         integer,
    @reference_number                       national character varying(24),
    @statement_reference                    national character varying(2000),
    @tender                                 decimal(30, 6),
    @change                                 decimal(30, 6),
    @payment_term_id                        integer,
    @check_amount                           decimal(30, 6),
    @check_bank_name                        national character varying(1000),
    @check_number                           national character varying(100),
    @check_date                             date,
    @gift_card_number                       national character varying(100),
    @customer_id                            integer,
    @price_type_id                          integer,
    @shipper_id                             integer,
    @store_id                               integer,
    @coupon_code                            national character varying(100),
    @is_flat_discount                       bit,
    @discount                               decimal(30, 6),
    @details                                sales.sales_detail_type READONLY,
    @sales_quotation_id                     bigint,
    @sales_order_id                         bigint,
    @transaction_master_id                  bigint OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @book_name                      national character varying(48) = 'Sales Entry';
    DECLARE @checkout_id                    bigint;
    DECLARE @grand_total                    decimal(30, 6);
    DECLARE @discount_total                 decimal(30, 6);
    DECLARE @receivable                     decimal(30, 6);
    DECLARE @default_currency_code          national character varying(12);
    DECLARE @is_periodic                    bit = inventory.is_periodic_inventory(@office_id);
    DECLARE @cost_of_goods                    decimal(30, 6);
    DECLARE @tran_counter                   integer;
    DECLARE @transaction_code               national character varying(50);
    DECLARE @tax_total                      decimal(30, 6);
    DECLARE @shipping_charge                decimal(30, 6);
    DECLARE @cash_repository_id             integer;
    DECLARE @cash_account_id                integer;
    DECLARE @is_cash                        bit = 0;
    DECLARE @is_credit                      bit = 0;
    DECLARE @gift_card_id                   integer;
    DECLARE @gift_card_balance              numeric(30, 6);
    DECLARE @coupon_id                      integer;
    DECLARE @coupon_discount                numeric(30, 6); 
    DECLARE @default_discount_account_id    integer;
    DECLARE @fiscal_year_code               national character varying(12);
    DECLARE @invoice_number                 bigint;
    DECLARE @tax_account_id                 integer;

    DECLARE @total_rows                     integer = 0;
    DECLARE @counter                        integer = 0;
    DECLARE @loop_id                        integer;
    DECLARE @loop_checkout_id               bigint
    DECLARE @loop_tran_type                 national character varying(2)
    DECLARE @loop_store_id                  integer;
    DECLARE @loop_item_id                   integer;
    DECLARE @loop_quantity                  decimal(30, 6);
    DECLARE @loop_unit_id                   integer;
    DECLARE @loop_base_quantity             decimal(30, 6);
    DECLARE @loop_base_unit_id              integer;
    DECLARE @loop_price                     decimal(30, 6);
    DECLARE @loop_cost_of_goods_sold        decimal(30, 6);
    DECLARE @loop_discount                  decimal(30, 6);
    DECLARE @loop_tax                       decimal(30, 6);
    DECLARE @loop_shipping_charge           decimal(30, 6);


    DECLARE @can_post_transaction           bit;
    DECLARE @error_message                  national character varying(MAX);

    SELECT
        @can_post_transaction   = can_post_transaction,
        @error_message          = error_message
    FROM finance.can_post_transaction(@login_id, @user_id, @office_id, @book_name, @value_date);

    IF(@can_post_transaction = 0)
    BEGIN
        RAISERROR(@error_message, 10, 1);
        RETURN;
    END;

    SET @tax_account_id                         = finance.get_sales_tax_account_id_by_office_id(@office_id);
    SET @default_currency_code                  = core.get_currency_code_by_office_id(@office_id);
    SET @cash_account_id                        = inventory.get_cash_account_id_by_store_id(@store_id);
    SET @cash_repository_id                     = inventory.get_cash_repository_id_by_store_id(@store_id);
    SET @is_cash                                = finance.is_cash_account_id(@cash_account_id);    

    SET @coupon_id                              = sales.get_active_coupon_id_by_coupon_code(@coupon_code);
    SET @gift_card_id                           = sales.get_gift_card_id_by_gift_card_number(@gift_card_number);
    SET @gift_card_balance                      = sales.get_gift_card_balance(@gift_card_id, @value_date);


    SELECT TOP 1 @fiscal_year_code = finance.fiscal_year.fiscal_year_code
    FROM finance.fiscal_year
    WHERE @value_date BETWEEN finance.fiscal_year.starts_from AND finance.fiscal_year.ends_on;

    IF(COALESCE(@customer_id, 0) = 0)
    BEGIN
        RAISERROR('Please select a customer.', 10, 1);
    END;

    IF(COALESCE(@coupon_code, '') != '' AND COALESCE(@discount, 0) > 0)
    BEGIN
        RAISERROR('Please do not specify discount rate when you mention coupon code.', 10, 1);
    END;
    --TODO: VALIDATE COUPON CODE AND POST DISCOUNT

    IF(COALESCE(@payment_term_id, 0) > 0)
    BEGIN
        SET @is_credit                          = 1;
    END;

    IF(@is_credit = 0 AND @is_cash = 0)
    BEGIN
        RAISERROR('Cannot post sales. Invalid cash account mapping on store.', 10, 1);
    END;

   
    IF(@is_cash = 0)
    BEGIN
        SET @cash_repository_id                 = NULL;
    END;

    DECLARE @checkout_details TABLE
    (
        id                              integer IDENTITY PRIMARY KEY,
        checkout_id                     bigint, 
        tran_type                       national character varying(2), 
        store_id                        integer,
        item_id                         integer, 
        quantity                        decimal(30, 6),        
        unit_id                         integer,
        base_quantity                   decimal(30, 6),
        base_unit_id                    integer,                
        price                           decimal(30, 6),
        cost_of_goods_sold              decimal(30, 6) DEFAULT(0),
        discount_rate                   decimal(30, 6),
        discount                        decimal(30, 6),
        tax                             decimal(30, 6),
        shipping_charge                 decimal(30, 6),
        sales_account_id                integer,
        sales_discount_account_id       integer,
        inventory_account_id            integer,
        cost_of_goods_sold_account_id   integer
    ) ;

    INSERT INTO @checkout_details(store_id, item_id, quantity, unit_id, price, discount_rate, tax, shipping_charge)
    SELECT store_id, item_id, quantity, unit_id, price, discount_rate, tax, shipping_charge
    FROM @details;

    
    UPDATE @checkout_details 
    SET
        tran_type                       = 'Cr',
        base_quantity                   = inventory.get_base_quantity_by_unit_id(unit_id, quantity),
        base_unit_id                    = inventory.get_root_unit_id(unit_id),
        discount                        = ROUND((price * quantity) * (discount_rate / 100), 2);


    UPDATE @checkout_details
    SET
        sales_account_id                = inventory.get_sales_account_id(item_id),
        sales_discount_account_id       = inventory.get_sales_discount_account_id(item_id),
        inventory_account_id            = inventory.get_inventory_account_id(item_id),
        cost_of_goods_sold_account_id   = inventory.get_cost_of_goods_sold_account_id(item_id);

    DECLARE @item_quantities TABLE
    (
        item_id             integer,
        base_unit_id        integer,
        store_id            integer,
        total_sales         numeric(30, 6),
        in_stock            numeric(30, 6),
        maintain_inventory      bit
    ) ;

    INSERT INTO @item_quantities(item_id, base_unit_id, store_id, total_sales)
    SELECT item_id, base_unit_id, store_id, SUM(base_quantity)
    FROM @checkout_details
    GROUP BY item_id, base_unit_id, store_id;

    UPDATE @item_quantities
    SET maintain_inventory = inventory.items.maintain_inventory
    FROM @item_quantities AS item_quantities 
    INNER JOIN inventory.items
    ON item_quantities.item_id = inventory.items.item_id;
    
    UPDATE @item_quantities
    SET in_stock = inventory.count_item_in_stock(item_id, base_unit_id, store_id)
    WHERE maintain_inventory = 1;


    IF EXISTS
    (
        SELECT TOP 1 0 FROM @item_quantities
        WHERE total_sales > in_stock
        AND maintain_inventory = 1     
    )
    BEGIN
        RAISERROR('Insufficient item quantity', 10, 1);
    END;
    
    IF EXISTS
    (
        SELECT TOP 1 0 FROM @checkout_details AS details
        WHERE inventory.is_valid_unit_id(details.unit_id, details.item_id) = 0
    )
    BEGIN
        RAISERROR('Item/unit mismatch.', 10, 1);
    END;

    SELECT @discount_total  = ROUND(SUM(COALESCE(discount, 0)), 2) FROM @checkout_details;
    SELECT @grand_total     = SUM(COALESCE(price, 0) * COALESCE(quantity, 0)) FROM @checkout_details;
    SELECT @shipping_charge = SUM(COALESCE(shipping_charge, 0)) FROM @checkout_details;
    SELECT @tax_total       = ROUND(SUM(COALESCE(tax, 0)), 2) FROM @checkout_details;

     
    SET @receivable         = COALESCE(@grand_total, 0) - COALESCE(@discount_total, 0) + COALESCE(@tax_total, 0) + COALESCE(@shipping_charge, 0);
        
    IF(@is_flat_discount = 1 AND @discount > @receivable)
    BEGIN
        RAISERROR('The discount amount cannot be greater than total amount.', 10, 1);
    END
    ELSE IF(@is_flat_discount = 0 AND @discount > 100)
    BEGIN
        RAISERROR('The discount rate cannot be greater than 100.', 10, 1);
    END;

    SET @coupon_discount                = ROUND(@discount, 2);

    IF(@is_flat_discount = 0 AND COALESCE(@discount, 0) > 0)
    BEGIN
        SET @coupon_discount            = ROUND(@receivable * (@discount/100), 2);
    END;

    IF(COALESCE(@coupon_discount, 0) > 0)
    BEGIN
        SET @discount_total             = @discount_total + @coupon_discount;
        SET @receivable                 = @receivable - @coupon_discount;
    END;

    IF(@tender > 0)
    BEGIN
        IF(@tender < @receivable)
        BEGIN
            SET @error_message = FORMATMESSAGE('The tender amount must be greater than or equal to %s.', CAST(@receivable AS varchar(30)));
            RAISERROR(@error_message, 10, 1);
        END;
    END
    ELSE IF(@check_amount > 0)
    BEGIN
        IF(@check_amount < @receivable )
        BEGIN
            SET @error_message = FORMATMESSAGE('The check amount must be greater than or equal to %s.', CAST(@receivable AS varchar(30)));
            RAISERROR(@error_message, 10, 1);
        END;
    END
    ELSE IF(COALESCE(@gift_card_number, '') != '')
    BEGIN
        IF(@gift_card_balance < @receivable )
        BEGIN
            SET @error_message = FORMATMESSAGE('The gift card must have a balance of at least %s.', CAST(@receivable AS varchar(30)));
            RAISERROR(@error_message, 10, 1);
        END;
    END;
    
    DECLARE @temp_transaction_details TABLE
    (
        transaction_master_id       BIGINT, 
        tran_type                   national character varying(2), 
        account_id                  integer NOT NULL, 
        statement_reference         national character varying(2000), 
        cash_repository_id          integer, 
        currency_code               national character varying(12), 
        amount_in_currency          decimal(30, 6) NOT NULL, 
        local_currency_code         national character varying(12), 
        er                          decimal(30, 6), 
        amount_in_local_currency    decimal(30, 6)
    ) ;


    INSERT INTO @temp_transaction_details(tran_type, account_id, statement_reference, currency_code, amount_in_currency, er, local_currency_code, amount_in_local_currency)
    SELECT 'Cr', sales_account_id, @statement_reference, @default_currency_code, SUM(COALESCE(price, 0) * COALESCE(quantity, 0)), 1, @default_currency_code, SUM(COALESCE(price, 0) * COALESCE(quantity, 0))
    FROM @checkout_details
    GROUP BY sales_account_id;

    IF(@is_periodic = 0)
    BEGIN
        --Perpetutal Inventory Accounting System

        UPDATE @checkout_details SET cost_of_goods_sold = inventory.get_cost_of_goods_sold(item_id, unit_id, store_id, quantity);
        
        SELECT @cost_of_goods = SUM(cost_of_goods_sold)
        FROM @checkout_details;


        IF(@cost_of_goods > 0)
        BEGIN
            INSERT INTO @temp_transaction_details(tran_type, account_id, statement_reference, currency_code, amount_in_currency, er, local_currency_code, amount_in_local_currency)
            SELECT 'Dr', cost_of_goods_sold_account_id, @statement_reference, @default_currency_code, SUM(COALESCE(cost_of_goods_sold, 0)), 1, @default_currency_code, SUM(COALESCE(cost_of_goods_sold, 0))
            FROM @checkout_details
            GROUP BY cost_of_goods_sold_account_id;

            INSERT INTO @temp_transaction_details(tran_type, account_id, statement_reference, currency_code, amount_in_currency, er, local_currency_code, amount_in_local_currency)
            SELECT 'Cr', inventory_account_id, @statement_reference, @default_currency_code, SUM(COALESCE(cost_of_goods_sold, 0)), 1, @default_currency_code, SUM(COALESCE(cost_of_goods_sold, 0))
            FROM @checkout_details
            GROUP BY inventory_account_id;
        END;
    END;

    IF(COALESCE(@tax_total, 0) > 0)
    BEGIN
        INSERT INTO @temp_transaction_details(tran_type, account_id, statement_reference, currency_code, amount_in_currency, er, local_currency_code, amount_in_local_currency)
        SELECT 'Cr', @tax_account_id, @statement_reference, @default_currency_code, @tax_total, 1, @default_currency_code, @tax_total;
    END;

    IF(COALESCE(@shipping_charge, 0) > 0)
    BEGIN
        INSERT INTO @temp_transaction_details(tran_type, account_id, statement_reference, currency_code, amount_in_currency, er, local_currency_code, amount_in_local_currency)
        SELECT 'Cr', inventory.get_account_id_by_shipper_id(@shipper_id), @statement_reference, @default_currency_code, @shipping_charge, 1, @default_currency_code, @shipping_charge;                
    END;


    IF(@discount_total > 0)
    BEGIN
        INSERT INTO @temp_transaction_details(tran_type, account_id, statement_reference, currency_code, amount_in_currency, er, local_currency_code, amount_in_local_currency)
        SELECT 'Dr', sales_discount_account_id, @statement_reference, @default_currency_code, SUM(COALESCE(discount, 0)), 1, @default_currency_code, SUM(COALESCE(discount, 0))
        FROM @checkout_details
        GROUP BY sales_discount_account_id
        HAVING SUM(COALESCE(discount, 0)) > 0;
    END;


    IF(@coupon_discount > 0)
    BEGIN
        SELECT @default_discount_account_id = inventory.inventory_setup.default_discount_account_id
        FROM inventory.inventory_setup
        WHERE inventory.inventory_setup.office_id = @office_id;

        INSERT INTO @temp_transaction_details(tran_type, account_id, statement_reference, currency_code, amount_in_currency, er, local_currency_code, amount_in_local_currency)
        SELECT 'Dr', @default_discount_account_id, @statement_reference, @default_currency_code, @coupon_discount, 1, @default_currency_code, @coupon_discount;
    END;



    INSERT INTO @temp_transaction_details(tran_type, account_id, statement_reference, currency_code, amount_in_currency, er, local_currency_code, amount_in_local_currency)
    SELECT 'Dr', inventory.get_account_id_by_customer_id(@customer_id), @statement_reference, @default_currency_code, @receivable, 1, @default_currency_code, @receivable;

    
    SET @tran_counter           = finance.get_new_transaction_counter(@value_date);
    SET @transaction_code       = finance.get_transaction_code(@value_date, @office_id, @user_id, @login_id);

    
    INSERT INTO finance.transaction_master(transaction_counter, transaction_code, book, value_date, book_date, user_id, login_id, office_id, cost_center_id, reference_number, statement_reference) 
    SELECT @tran_counter, @transaction_code, @book_name, @value_date, @book_date, @user_id, @login_id, @office_id, @cost_center_id, @reference_number, @statement_reference;
    SET @transaction_master_id  = SCOPE_IDENTITY();
    UPDATE @temp_transaction_details        SET transaction_master_id   = @transaction_master_id;


    INSERT INTO finance.transaction_details(value_date, book_date, office_id, transaction_master_id, tran_type, account_id, statement_reference, cash_repository_id, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency)
    SELECT @value_date, @book_date, @office_id, transaction_master_id, tran_type, account_id, statement_reference, cash_repository_id, currency_code, amount_in_currency, local_currency_code, er, amount_in_local_currency
    FROM @temp_transaction_details
    ORDER BY tran_type DESC;


    INSERT INTO inventory.checkouts(transaction_book, value_date, book_date, transaction_master_id, shipper_id, posted_by, office_id, discount)
    SELECT @book_name, @value_date, @book_date, @transaction_master_id, @shipper_id, @user_id, @office_id, @coupon_discount;

    SET @checkout_id              = SCOPE_IDENTITY();    
    
    UPDATE @checkout_details
    SET checkout_id             = @checkout_id;

    SELECT @total_rows=MAX(id) FROM @checkout_details;

    WHILE @counter<@total_rows
    BEGIN
        SELECT TOP 1 
            @loop_id                    = id,
            @loop_checkout_id           = checkout_id,
            @loop_tran_type             = tran_type,
            @loop_store_id              = store_id,
            @loop_item_id               = item_id,
            @loop_quantity              = quantity,
            @loop_unit_id               = unit_id,
            @loop_base_quantity         = base_quantity,
            @loop_base_unit_id          = base_unit_id,
            @loop_price                 = price,
            @loop_cost_of_goods_sold    = cost_of_goods_sold,
            @loop_discount              = discount,
            @loop_tax                   = tax,
            @loop_shipping_charge       = shipping_charge
        FROM @checkout_details
        WHERE id >= @counter
        ORDER BY id;

        IF(@loop_id IS NOT NULL)
        BEGIN
            SET @counter = @loop_id + 1;        
        END
        ELSE
        BEGIN
            BREAK;
        END;

        INSERT INTO inventory.checkout_details(value_date, book_date, checkout_id, transaction_type, store_id, item_id, quantity, unit_id, base_quantity, base_unit_id, price, cost_of_goods_sold, discount, tax, shipping_charge)
        SELECT @value_date, @book_date, @loop_checkout_id, @loop_tran_type, @loop_store_id, @loop_item_id, @loop_quantity, @loop_unit_id, @loop_base_quantity, @loop_base_unit_id, @loop_price, COALESCE(@loop_cost_of_goods_sold, 0), @loop_discount, @loop_tax, @loop_shipping_charge 
        FROM @checkout_details
        WHERE id = @loop_id;
    END;


    SELECT @invoice_number = COALESCE(MAX(invoice_number), 0) + 1
    FROM sales.sales
    WHERE sales.sales.fiscal_year_code = @fiscal_year_code;
    
    INSERT INTO sales.sales(fiscal_year_code, invoice_number, price_type_id, counter_id, total_amount, cash_repository_id, sales_order_id, sales_quotation_id, transaction_master_id, checkout_id, customer_id, salesperson_id, coupon_id, is_flat_discount, discount, total_discount_amount, is_credit, payment_term_id, tender, change, check_number, check_date, check_bank_name, check_amount, gift_card_id)
    SELECT @fiscal_year_code, @invoice_number, @price_type_id, @counter_id, @receivable, @cash_repository_id, @sales_order_id, @sales_quotation_id, @transaction_master_id, @checkout_id, @customer_id, @user_id, @coupon_id, @is_flat_discount, @discount, @discount_total, @is_credit, @payment_term_id, @tender, @change, @check_number, @check_date, @check_bank_name, @check_amount, @gift_card_id;
    
    EXECUTE finance.auto_verify @transaction_master_id, @office_id;

    IF(@is_credit = 0)
    BEGIN
        EXECUTE sales.post_receipt
            @user_id, 
            @office_id, 
            @login_id,
            @customer_id,
            @default_currency_code, 
            1.0, 
            1.0,
            @reference_number, 
            @statement_reference, 
            @cost_center_id,
            @cash_account_id,
            @cash_repository_id,
            @value_date,
            @book_date,
            @receivable,
            @tender,
            @change,
            @check_amount,
            @check_bank_name,
            @check_number,
            @check_date,
            @gift_card_number,
            @store_id,
            @transaction_master_id;
    END
    ELSE
    BEGIN
        EXECUTE sales.settle_customer_due @customer_id, @office_id;
    END;

    SELECT @transaction_master_id;
END;

GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.settle_customer_due.sql --<--<--
IF OBJECT_ID('sales.settle_customer_due') IS NOT NULL
DROP PROCEDURE sales.settle_customer_due;

GO

CREATE PROCEDURE sales.settle_customer_due(@customer_id bigint, @office_id integer)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @settled_transactions TABLE
    (
        transaction_master_id               bigint
    );

    DECLARE @settling_amount                numeric(30, 6);
    DECLARE @closing_balance                numeric(30, 6);
    DECLARE @total_sales                    numeric(30, 6);
    DECLARE @customer_account_id            integer = inventory.get_account_id_by_customer_id(@customer_id);

    --Closing balance of the customer
    SELECT
        @closing_balance = SUM
        (
            CASE WHEN tran_type = 'Cr' 
            THEN amount_in_local_currency 
            ELSE amount_in_local_currency  * -1 
            END
        )
    FROM finance.transaction_details
    INNER JOIN finance.transaction_master
    ON finance.transaction_master.transaction_master_id = finance.transaction_details.transaction_master_id
    WHERE finance.transaction_master.verification_status_id > 0
    AND finance.transaction_master.deleted = 0
    AND finance.transaction_master.office_id = @office_id
    AND finance.transaction_details.account_id = @customer_account_id;


    --Since customer account is receivable, change the balance to debit
    SET @closing_balance = @closing_balance * -1;

    --Sum of total sales amount
    SELECT 
        @total_sales = SUM
        (
            (inventory.checkout_details.quantity * inventory.checkout_details.price) 
            - 
            inventory.checkout_details.discount 
            + 
            inventory.checkout_details.tax
            + 
            inventory.checkout_details.shipping_charge
        )
    FROM inventory.checkouts
    INNER JOIN sales.sales
    ON sales.sales.checkout_id = inventory.checkouts.checkout_id
    INNER JOIN inventory.checkout_details
    ON inventory.checkouts.checkout_id = inventory.checkout_details.checkout_id
    INNER JOIN finance.transaction_master
    ON inventory.checkouts.transaction_master_id = finance.transaction_master.transaction_master_id
    WHERE finance.transaction_master.verification_status_id > 0
    AND finance.transaction_master.office_id = @office_id
    AND sales.sales.customer_id = @customer_id;


    SET @settling_amount = @total_sales - @closing_balance;

    WITH all_sales
    AS
    (
        SELECT 
            inventory.checkouts.transaction_master_id,
            SUM
            (
                (inventory.checkout_details.quantity * inventory.checkout_details.price) 
                - 
                inventory.checkout_details.discount 
                + 
                inventory.checkout_details.tax
                + 
                inventory.checkout_details.shipping_charge
            ) as due
        FROM inventory.checkouts
        INNER JOIN sales.sales
        ON sales.sales.checkout_id = inventory.checkouts.checkout_id
        INNER JOIN inventory.checkout_details
        ON inventory.checkouts.checkout_id = inventory.checkout_details.checkout_id
        INNER JOIN finance.transaction_master
        ON inventory.checkouts.transaction_master_id = finance.transaction_master.transaction_master_id
        WHERE finance.transaction_master.book IN('Sales.Direct', 'Sales.Delivery')
        AND finance.transaction_master.office_id = @office_id
        AND finance.transaction_master.verification_status_id > 0      --Approved
        AND sales.sales.customer_id = @customer_id                     --of this customer
        GROUP BY inventory.checkouts.transaction_master_id
    ),
    sales_summary
    AS
    (
        SELECT 
            transaction_master_id, 
            due, 
            SUM(due) OVER(ORDER BY transaction_master_id) AS cumulative_due
        FROM all_sales
    )

    INSERT INTO @settled_transactions
    SELECT transaction_master_id
    FROM sales_summary
    WHERE cumulative_due <= @settling_amount;

    UPDATE sales.sales
    SET credit_settled = 1
    WHERE transaction_master_id IN
    (
        SELECT transaction_master_id 
        FROM @settled_transactions
    );
END;

GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/02.functions-and-logic/sales.validate_items_for_return.sql --<--<--
IF OBJECT_ID('sales.validate_items_for_return') IS NOT NULL
DROP FUNCTION sales.validate_items_for_return;

GO

CREATE FUNCTION sales.validate_items_for_return
(
    @transaction_master_id                  bigint, 
    @details                                sales.sales_detail_type READONLY
)
RETURNS @result TABLE
(
    is_valid                                bit,
    error_message                           national character varying(2000)
)
AS
BEGIN        
    DECLARE @checkout_id                    bigint = 0;
    DECLARE @is_purchase                    bit = 0;
    DECLARE @item_id                        integer = 0;
    DECLARE @factor_to_base_unit            numeric(30, 6);
    DECLARE @returned_in_previous_batch     decimal(30, 6) = 0;
    DECLARE @in_verification_queue          decimal(30, 6) = 0;
    DECLARE @actual_price_in_root_unit      decimal(30, 6) = 0;
    DECLARE @price_in_root_unit             decimal(30, 6) = 0;
    DECLARE @item_in_stock                  decimal(30, 6) = 0;
    DECLARE @error_item_id                  integer;
    DECLARE @error_quantity                 decimal(30, 6);
    DECLARE @error_amount                   decimal(30, 6);
    DECLARE @error_message                  national character varying(MAX);

    DECLARE @total_rows                     integer = 0;
    DECLARE @counter                        integer = 0;
    DECLARE @loop_id                        integer;
    DECLARE @loop_item_id                   integer;
    DECLARE @loop_price                     decimal(30, 6);
    DECLARE @loop_base_quantity             numeric(30, 6);

    SET @checkout_id                        = inventory.get_checkout_id_by_transaction_master_id(@transaction_master_id);

    INSERT INTO @result(is_valid, error_message)
    SELECT 0, '';


    DECLARE @details_temp TABLE
    (
        id                  integer IDENTITY,
        store_id            integer,
        item_id             integer,
        item_in_stock       numeric(30, 6),
        quantity            decimal(30, 6),        
        unit_id             integer,
        price               decimal(30, 6),
        discount_rate       decimal(30, 6),
        tax                 decimal(30, 6),
        shipping_charge     decimal(30, 6),
        root_unit_id        integer,
        base_quantity       numeric(30, 6)
    ) ;

    INSERT INTO @details_temp(store_id, item_id, quantity, unit_id, price, discount_rate, tax, shipping_charge)
    SELECT store_id, item_id, quantity, unit_id, price, discount_rate, tax, shipping_charge
    FROM @details;

    UPDATE @details_temp
    SET 
        item_in_stock = inventory.count_item_in_stock(item_id, unit_id, store_id);
       
    UPDATE @details_temp
    SET root_unit_id = inventory.get_root_unit_id(unit_id);

    UPDATE @details_temp
    SET base_quantity = inventory.convert_unit(unit_id, root_unit_id) * quantity;


    --Determine whether the quantity of the returned item(s) is less than or equal to the same on the actual transaction
    DECLARE @item_summary TABLE
    (
        store_id                    integer,
        item_id                     integer,
        root_unit_id                integer,
        returned_quantity           numeric(30, 6),
        actual_quantity             numeric(30, 6),
        returned_in_previous_batch  numeric(30, 6),
        in_verification_queue       numeric(30, 6)
    ) ;
    
    INSERT INTO @item_summary(store_id, item_id, root_unit_id, returned_quantity)
    SELECT
        store_id,
        item_id,
        root_unit_id, 
        SUM(base_quantity)
    FROM @details_temp
    GROUP BY 
        store_id, 
        item_id,
        root_unit_id;

    UPDATE @item_summary
    SET actual_quantity = 
    (
        SELECT SUM(base_quantity)
        FROM inventory.checkout_details
        WHERE inventory.checkout_details.checkout_id = @checkout_id
        AND inventory.checkout_details.item_id = item_summary.item_id
    )
    FROM @item_summary AS item_summary;

    UPDATE @item_summary
    SET returned_in_previous_batch = 
    (
        SELECT 
            COALESCE(SUM(base_quantity), 0)
        FROM inventory.checkout_details
        WHERE checkout_id IN
        (
            SELECT checkout_id
            FROM inventory.checkouts
            INNER JOIN finance.transaction_master
            ON finance.transaction_master.transaction_master_id = inventory.checkouts.transaction_master_id
            WHERE finance.transaction_master.verification_status_id > 0
            AND inventory.checkouts.transaction_master_id IN 
            (
                SELECT 
                    return_transaction_master_id 
                FROM sales.returns
                WHERE transaction_master_id = @transaction_master_id
            )
        )
        AND item_id = item_summary.item_id
    )
    FROM @item_summary AS item_summary;

    UPDATE @item_summary
    SET in_verification_queue =
    (
        SELECT 
            COALESCE(SUM(base_quantity), 0)
        FROM inventory.checkout_details
        WHERE checkout_id IN
        (
            SELECT checkout_id
            FROM inventory.checkouts
            INNER JOIN finance.transaction_master
            ON finance.transaction_master.transaction_master_id = inventory.checkouts.transaction_master_id
            WHERE finance.transaction_master.verification_status_id = 0
            AND inventory.checkouts.transaction_master_id IN 
            (
                SELECT 
                return_transaction_master_id 
                FROM sales.returns
                WHERE transaction_master_id = @transaction_master_id
            )
        )
        AND item_id = item_summary.item_id
    )
    FROM @item_summary AS item_summary;
    
    --Determine whether the price of the returned item(s) is less than or equal to the same on the actual transaction
    DECLARE @cumulative_pricing TABLE
    (
        item_id                     integer,
        base_price                  numeric(30, 6),
        allowed_returns             numeric(30, 6)
    ) ;

    INSERT INTO @cumulative_pricing
    SELECT 
        item_id,
        MIN(price  / base_quantity * quantity) as base_price,
        SUM(base_quantity) OVER(ORDER BY item_id, base_quantity) as allowed_returns
    FROM inventory.checkout_details 
    WHERE checkout_id = @checkout_id
    GROUP BY item_id, base_quantity;

    IF EXISTS(SELECT 0 FROM @details_temp WHERE store_id IS NULL OR store_id <= 0)
    BEGIN
        UPDATE @result 
        SET 
            is_valid = 0, 
            error_message = 'Invalid store.';
        RETURN;
    END;    

    IF EXISTS(SELECT 0 FROM @details_temp WHERE item_id IS NULL OR item_id <= 0)
    BEGIN
        UPDATE @result 
        SET 
            is_valid = 0, 
            error_message = 'Invalid item.';

        RETURN;
    END;

    IF EXISTS(SELECT 0 FROM @details_temp WHERE unit_id IS NULL OR unit_id <= 0)
    BEGIN
        UPDATE @result 
        SET 
            is_valid = 0, 
            error_message = 'Invalid unit.';
        RETURN;
    END;

    IF EXISTS(SELECT 0 FROM @details_temp WHERE quantity IS NULL OR quantity <= 0)
    BEGIN
        UPDATE @result 
        SET 
            is_valid = 0, 
            error_message = 'Invalid quantity.';
        RETURN;
    END;

    IF(@checkout_id  IS NULL OR @checkout_id  <= 0)
    BEGIN
        UPDATE @result 
        SET 
            is_valid = 0, 
            error_message = 'Invalid transaction id.';
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT * FROM finance.transaction_master
        WHERE transaction_master_id = @transaction_master_id
        AND verification_status_id > 0
    )
    BEGIN
        UPDATE @result 
        SET 
            is_valid = 0, 
            error_message = 'Invalid or rejected transaction.';
        RETURN;
    END;
        
    SELECT @item_id = item_id
    FROM @details_temp
    WHERE item_id NOT IN
    (
        SELECT TOP 1 item_id FROM inventory.checkout_details
        WHERE checkout_id = @checkout_id
    );

    IF(COALESCE(@item_id, 0) != 0)
    BEGIN
        SET @error_message = FORMATMESSAGE('The item %s is not associated with this transaction.', inventory.get_item_name_by_item_id(1));

        UPDATE @result 
        SET 
            is_valid = 0, 
            error_message = @error_message;
        RETURN;
    END;


    IF NOT EXISTS
    (
        SELECT TOP 1 0 FROM inventory.checkout_details
        INNER JOIN @details_temp AS details_temp
        ON inventory.checkout_details.item_id = details_temp.item_id
        WHERE checkout_id = @checkout_id
        AND inventory.get_root_unit_id(details_temp.unit_id) = inventory.get_root_unit_id(inventory.checkout_details.unit_id)
    )
    BEGIN
        UPDATE @result 
        SET 
            is_valid = 0, 
            error_message = 'Invalid or incompatible unit specified.';
        RETURN;
    END;

    SELECT TOP 1
        @error_item_id = item_id,
        @error_quantity = returned_quantity        
    FROM @item_summary
    WHERE returned_quantity + returned_in_previous_batch + in_verification_queue > actual_quantity;

    IF(@error_item_id IS NOT NULL)
    BEGIN
        SET @error_message = FORMATMESSAGE('The returned quantity (%s) of %s is greater than actual quantity.', CAST(@error_quantity AS varchar(30)), inventory.get_item_name_by_item_id(@error_item_id));

        UPDATE @result 
        SET 
            is_valid = 0, 
            error_message = @error_message;
        RETURN;
    END;


    SELECT @total_rows=MAX(id) FROM @details_temp;

    WHILE @counter<@total_rows
    BEGIN

        SELECT TOP 1
            @loop_id                = id,
            @loop_item_id           = item_id,
            @loop_price             = CAST((price / base_quantity * quantity) AS numeric(30, 6)),
            @loop_base_quantity     = base_quantity
        FROM @details_temp
        WHERE id >= @counter
        ORDER BY id;

        IF(@loop_id IS NOT NULL)
        BEGIN
            SET @counter = @loop_id + 1;        
        END
        ELSE
        BEGIN
            BREAK;
        END;


        SELECT TOP 1
            @error_item_id = item_id,
            @error_amount = base_price
        FROM @cumulative_pricing
        WHERE item_id = @loop_item_id
        AND base_price <  @loop_price
        AND allowed_returns >= @loop_base_quantity;
        
        IF (@error_item_id IS NOT NULL)
        BEGIN
            SET @error_message = FORMATMESSAGE
            (
                'The returned base amount %s of %s cannot be greater than actual amount %s.', 
                CAST(@loop_price AS varchar(30)), 
                inventory.get_item_name_by_item_id(@error_item_id), 
                CAST(@error_amount AS varchar(30))
            );

            UPDATE @result 
            SET 
                is_valid = 0, 
                error_message = @error_message;
        RETURN;
        END;
    END;
    
    UPDATE @result 
    SET 
        is_valid = 1, 
        error_message = '';
    RETURN;
END;

GO



-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/03.menus/menus.sql --<--<--
DELETE FROM auth.menu_access_policy
WHERE menu_id IN
(
    SELECT menu_id FROM core.menus
    WHERE app_name = 'Sales'
);

DELETE FROM auth.group_menu_access_policy
WHERE menu_id IN
(
    SELECT menu_id FROM core.menus
    WHERE app_name = 'Sales'
);

DELETE FROM core.menus
WHERE app_name = 'Sales';


EXECUTE core.create_app 'Sales', 'Sales', '1.0', 'MixERP Inc.', 'December 1, 2015', 'shipping blue', '/dashboard/sales/tasks/entry', NULL;

EXECUTE core.create_menu 'Sales', 'Tasks', '', 'lightning', '';
EXECUTE core.create_menu 'Sales', 'Opening Cash', '/dashboard/sales/tasks/opening-cash', 'money', 'Tasks';
EXECUTE core.create_menu 'Sales', 'Sales Entry', '/dashboard/sales/tasks/entry', 'write', 'Tasks';
EXECUTE core.create_menu 'Sales', 'Sales Returns', '/dashboard/sales/tasks/return', 'minus square', 'Tasks';
EXECUTE core.create_menu 'Sales', 'Sales Quotation', '/dashboard/sales/tasks/quotation', 'quote left', 'Tasks';
EXECUTE core.create_menu 'Sales', 'Sales Orders', '/dashboard/sales/tasks/order', 'file national character varying(1000) outline', 'Tasks';
EXECUTE core.create_menu 'Sales', 'Sales Entry Verification', '/dashboard/sales/tasks/entry/verification', 'checkmark', 'Tasks';
EXECUTE core.create_menu 'Sales', 'Sales Return Verification', '/dashboard/sales/tasks/return/verification', 'checkmark box', 'Tasks';
--EXECUTE core.create_menu 'Sales', 'Check Clearing', '/dashboard/sales/tasks/checks/checks-clearing', 'minus square outline', 'Tasks';
EXECUTE core.create_menu 'Sales', 'EOD', '/dashboard/sales/tasks/eod', 'money', 'Tasks';

EXECUTE core.create_menu 'Sales', 'Customer Loyalty', 'square outline', 'user', '';
EXECUTE core.create_menu 'Sales', 'Gift Cards', '/dashboard/sales/loyalty/gift-cards', 'gift', 'Customer Loyalty';
EXECUTE core.create_menu 'Sales', 'Add Gift Card Fund', '/dashboard/loyalty/tasks/gift-cards/add-fund', 'pound', 'Customer Loyalty';
EXECUTE core.create_menu 'Sales', 'Verify Gift Card Fund', '/dashboard/loyalty/tasks/gift-cards/add-fund/verification', 'checkmark', 'Customer Loyalty';
EXECUTE core.create_menu 'Sales', 'Sales Coupons', '/dashboard/sales/loyalty/coupons', 'browser', 'Customer Loyalty';
--EXECUTE core.create_menu 'Sales', 'Loyalty Point Configuration', '/dashboard/sales/loyalty/points', 'selected radio', 'Customer Loyalty';

EXECUTE core.create_menu 'Sales', 'Setup', 'square outline', 'configure', '';
EXECUTE core.create_menu 'Sales', 'Customer Types', '/dashboard/sales/setup/customer-types', 'child', 'Setup';
EXECUTE core.create_menu 'Sales', 'Customers', '/dashboard/sales/setup/customers', 'street view', 'Setup';
EXECUTE core.create_menu 'Sales', 'Price Types', '/dashboard/sales/setup/price-types', 'ruble', 'Setup';
EXECUTE core.create_menu 'Sales', 'Selling Prices', '/dashboard/sales/setup/selling-prices', 'in cart', 'Setup';
EXECUTE core.create_menu 'Sales', 'Late Fee', '/dashboard/sales/setup/late-fee', 'alarm mute', 'Setup';
EXECUTE core.create_menu 'Sales', 'Payment Terms', '/dashboard/sales/setup/payment-terms', 'checked calendar', 'Setup';
EXECUTE core.create_menu 'Sales', 'Cashiers', '/dashboard/sales/setup/cashiers', 'male', 'Setup';

EXECUTE core.create_menu 'Sales', 'Reports', '', 'block layout', '';
EXECUTE core.create_menu 'Sales', 'All Gift Cards', '/dashboard/sales/reports/gift-cards/account-statement', 'certificate', 'Reports';
EXECUTE core.create_menu 'Sales', 'Gift Card Usage Statement', '/dashboard/sales/reports/gift-cards/account-statement', 'columns', 'Reports';
EXECUTE core.create_menu 'Sales', 'Customer Account Statement', '/dashboard/sales/reports/customer/account-statement', 'content', 'Reports';
EXECUTE core.create_menu 'Sales', 'Credit Statement', '/dashboard/sales/reports/credit-statement', 'newspaper', 'Reports';
EXECUTE core.create_menu 'Sales', 'Top Selling Items', '/dashboard/sales/reports/sales-account-statement', 'map signs', 'Reports';
EXECUTE core.create_menu 'Sales', 'Sales by Office', '/dashboard/sales/reports/sales-account-statement', 'building', 'Reports';


DECLARE @office_id integer = core.get_office_id_by_office_name('Default');
EXECUTE auth.create_app_menu_policy
'Admin', 
@office_id, 
'Sales',
'{*}';


GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/04.default-values/01.default-values.sql --<--<--


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/05.scrud-views/sales.cashier_scrud_view.sql --<--<--
IF OBJECT_ID('sales.cashier_scrud_view') IS NOT NULL
DROP VIEW sales.cashier_scrud_view;

GO



CREATE VIEW sales.cashier_scrud_view
AS
SELECT
    sales.cashiers.cashier_id,
    sales.cashiers.cashier_code,
    account.users.name AS associated_user,
    inventory.counters.counter_code + ' (' + inventory.counters.counter_name + ')' AS counter,
    sales.cashiers.valid_from,
    sales.cashiers.valid_till
FROM sales.cashiers
INNER JOIN account.users
ON account.users.user_id = sales.cashiers.associated_user_id
INNER JOIN inventory.counters
ON inventory.counters.counter_id = sales.cashiers.counter_id
WHERE sales.cashiers.deleted = 0;

GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/05.scrud-views/sales.item_selling_price_scrud_view.sql --<--<--
IF OBJECT_ID('sales.item_selling_price_scrud_view') IS NOT NULL
DROP VIEW sales.item_selling_price_scrud_view;

GO



CREATE VIEW sales.item_selling_price_scrud_view
AS
SELECT 
    sales.item_selling_prices.item_selling_price_id,
    inventory.items.item_code + ' (' + inventory.items.item_name + ')' AS item,
    inventory.units.unit_code + ' (' + inventory.units.unit_name + ')' AS unit,
    inventory.customer_types.customer_type_code + ' (' + inventory.customer_types.customer_type_name + ')' AS customer_type,
    sales.price_types.price_type_code + ' (' + sales.price_types.price_type_name + ')' AS price_type,
    sales.item_selling_prices.includes_tax,
    sales.item_selling_prices.price
FROM sales.item_selling_prices
INNER JOIN inventory.items
ON inventory.items.item_id = sales.item_selling_prices.item_id
INNER JOIN inventory.units
ON inventory.units.unit_id = sales.item_selling_prices.unit_id
INNER JOIN inventory.customer_types
ON inventory.customer_types.customer_type_id = sales.item_selling_prices.customer_type_id
INNER JOIN sales.price_types
ON sales.price_types.price_type_id = sales.item_selling_prices.price_type_id
WHERE sales.item_selling_prices.deleted = 0;


GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/05.scrud-views/sales.payment_term_scrud_view.sql --<--<--
IF OBJECT_ID('sales.payment_term_scrud_view') IS NOT NULL
DROP VIEW sales.payment_term_scrud_view;

GO



CREATE VIEW sales.payment_term_scrud_view
AS
SELECT
    sales.payment_terms.payment_term_id,
    sales.payment_terms.payment_term_code,
    sales.payment_terms.payment_term_name,
    sales.payment_terms.due_on_date,
    sales.payment_terms.due_days,
    due_fequency.frequency_code + ' (' + due_fequency.frequency_name + ')' AS due_fequency,
    sales.payment_terms.grace_period,
    sales.late_fee.late_fee_code + ' (' + sales.late_fee.late_fee_name + ')' AS late_fee,
    late_fee_frequency.frequency_code + ' (' + late_fee_frequency.frequency_name + ')' AS late_fee_frequency
FROM sales.payment_terms
INNER JOIN finance.frequencies AS due_fequency
ON due_fequency.frequency_id = sales.payment_terms.due_frequency_id
INNER JOIN finance.frequencies AS late_fee_frequency
ON late_fee_frequency.frequency_id = sales.payment_terms.late_fee_posting_frequency_id
INNER JOIN sales.late_fee
ON sales.late_fee.late_fee_id = sales.payment_terms.late_fee_id
WHERE sales.payment_terms.deleted = 0;



GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/05.views/sales.coupon_view.sql --<--<--
IF OBJECT_ID('sales.coupon_view') IS NOT NULL
DROP VIEW sales.coupon_view;

GO



CREATE VIEW sales.coupon_view
AS
SELECT
    sales.coupons.coupon_id,
    sales.coupons.coupon_code,
    sales.coupons.coupon_name,
    sales.coupons.discount_rate,
    sales.coupons.is_percentage,
    sales.coupons.maximum_discount_amount,
    sales.coupons.associated_price_type_id,
    associated_price_type.price_type_code AS associated_price_type_code,
    associated_price_type.price_type_name AS associated_price_type_name,
    sales.coupons.minimum_purchase_amount,
    sales.coupons.maximum_purchase_amount,
    sales.coupons.begins_from,
    sales.coupons.expires_on,
    sales.coupons.maximum_usage,
    sales.coupons.enable_ticket_printing,
    sales.coupons.for_ticket_of_price_type_id,
    for_ticket_of_price_type.price_type_code AS for_ticket_of_price_type_code,
    for_ticket_of_price_type.price_type_name AS for_ticket_of_price_type_name,
    sales.coupons.for_ticket_having_minimum_amount,
    sales.coupons.for_ticket_having_maximum_amount,
    sales.coupons.for_ticket_of_unknown_customers_only
FROM sales.coupons
LEFT JOIN sales.price_types AS associated_price_type
ON associated_price_type.price_type_id = sales.coupons.associated_price_type_id
LEFT JOIN sales.price_types AS for_ticket_of_price_type
ON for_ticket_of_price_type.price_type_id = sales.coupons.for_ticket_of_price_type_id;



GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/05.views/sales.gift_card_search_view.sql --<--<--
IF OBJECT_ID('sales.gift_card_search_view') IS NOT NULL
DROP VIEW sales.gift_card_search_view;

GO



CREATE VIEW sales.gift_card_search_view
AS
SELECT
    sales.gift_cards.gift_card_id,
    sales.gift_cards.gift_card_number,
    REPLACE(COALESCE(sales.gift_cards.first_name + ' ', '') + COALESCE(sales.gift_cards.middle_name + ' ', '') + COALESCE(sales.gift_cards.last_name, ''), '  ', ' ') AS name,
    REPLACE(COALESCE(sales.gift_cards.address_line_1 + ' ', '') + COALESCE(sales.gift_cards.address_line_2 + ' ', '') + COALESCE(sales.gift_cards.street, ''), '  ', ' ') AS address,
    sales.gift_cards.city,
    sales.gift_cards.state,
    sales.gift_cards.country,
    sales.gift_cards.po_box,
    sales.gift_cards.zipcode,
    sales.gift_cards.phone_numbers,
    sales.gift_cards.fax    
FROM sales.gift_cards
WHERE sales.gift_cards.deleted = 0;



GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/05.views/sales.gift_card_transaction_view.sql --<--<--
IF OBJECT_ID('sales.gift_card_transaction_view') IS NOT NULL
DROP VIEW sales.gift_card_transaction_view;

GO



CREATE VIEW sales.gift_card_transaction_view
AS
SELECT
finance.transaction_master.transaction_master_id,
finance.transaction_master.transaction_ts,
finance.transaction_master.transaction_code,
finance.transaction_master.value_date,
finance.transaction_master.book_date,
account.users.name AS entered_by,
sales.gift_cards.first_name + ' ' + sales.gift_cards.middle_name + ' ' + sales.gift_cards.last_name AS customer_name,
sales.gift_card_transactions.amount,
finance.verification_statuses.verification_status_name AS status,
verified_by_user.name AS verified_by,
finance.transaction_master.verification_reason,
finance.transaction_master.last_verified_on,
core.offices.office_name,
finance.cost_centers.cost_center_name,
finance.transaction_master.reference_number,
finance.transaction_master.statement_reference,
account.get_name_by_user_id(finance.transaction_master.user_id) AS posted_by,
finance.transaction_master.office_id
FROM finance.transaction_master
INNER JOIN core.offices
ON finance.transaction_master.office_id = core.offices.office_id
INNER JOIN finance.cost_centers
ON finance.transaction_master.cost_center_id = finance.cost_centers.cost_center_id
INNER JOIN sales.gift_card_transactions
ON sales.gift_card_transactions.transaction_master_id = finance.transaction_master.transaction_master_id
INNER JOIN account.users
ON finance.transaction_master.user_id = account.users.user_id
LEFT JOIN sales.gift_cards
ON sales.gift_card_transactions.gift_card_id = sales.gift_cards.gift_card_id
INNER JOIN finance.verification_statuses
ON finance.transaction_master.verification_status_id = finance.verification_statuses.verification_status_id
LEFT JOIN account.users AS verified_by_user
ON finance.transaction_master.verified_by_user_id = verified_by_user.user_id;

--SELECT * FROM sales.gift_card_transaction_view;

GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/05.views/sales.item_view.sql --<--<--
IF OBJECT_ID('sales.item_view') IS NOT NULL
DROP VIEW sales.item_view;

GO



CREATE VIEW sales.item_view
AS
SELECT
    inventory.items.item_id,
    inventory.items.item_code,
    inventory.items.item_name,
    inventory.items.is_taxable_item,
    inventory.items.barcode,
    inventory.items.item_group_id,
    inventory.item_groups.item_group_name,
    inventory.item_types.item_type_id,
    inventory.item_types.item_type_name,
    inventory.items.brand_id,
    inventory.brands.brand_name,
    inventory.items.preferred_supplier_id,
    inventory.items.unit_id,
    inventory.get_associated_unit_list_csv(inventory.items.unit_id) AS valid_units,
    inventory.units.unit_code,
    inventory.units.unit_name,
    inventory.items.hot_item,
    inventory.items.selling_price,
    inventory.items.selling_price_includes_tax,
    inventory.items.photo
FROM inventory.items
INNER JOIN inventory.item_groups
ON inventory.item_groups.item_group_id = inventory.items.item_group_id
INNER JOIN inventory.item_types
ON inventory.item_types.item_type_id = inventory.items.item_type_id
INNER JOIN inventory.brands
ON inventory.brands.brand_id = inventory.items.brand_id
INNER JOIN inventory.units
ON inventory.units.unit_id = inventory.items.unit_id
WHERE inventory.items.deleted = 0
AND inventory.items.allow_sales = 1;


GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/05.views/sales.sales_view.sql --<--<--
IF OBJECT_ID('sales.sales_view') IS NOT NULL
DROP VIEW sales.sales_view;

GO



CREATE VIEW sales.sales_view
AS
SELECT
    sales.sales.sales_id,
    sales.sales.transaction_master_id,
    finance.transaction_master.transaction_code,
    finance.transaction_master.transaction_counter,
    finance.transaction_master.value_date,
    finance.transaction_master.book_date,
    finance.transaction_master.transaction_ts,
    finance.transaction_master.verification_status_id,
    finance.verification_statuses.verification_status_name,
    finance.transaction_master.verified_by_user_id,
    account.get_name_by_user_id(finance.transaction_master.verified_by_user_id) AS verified_by,
    sales.sales.checkout_id,
    inventory.checkouts.discount,
    inventory.checkouts.posted_by,
    account.get_name_by_user_id(inventory.checkouts.posted_by) AS posted_by_name,
    inventory.checkouts.office_id,
    inventory.checkouts.cancelled,
    inventory.checkouts.cancellation_reason,    
    sales.sales.cash_repository_id,
    finance.cash_repositories.cash_repository_code,
    finance.cash_repositories.cash_repository_name,
    sales.sales.price_type_id,
    sales.price_types.price_type_code,
    sales.price_types.price_type_name,
    sales.sales.counter_id,
    inventory.counters.counter_code,
    inventory.counters.counter_name,
    inventory.counters.store_id,
    inventory.stores.store_code,
    inventory.stores.store_name,
    sales.sales.customer_id,
    inventory.customers.customer_name,
    sales.sales.salesperson_id,
    account.get_name_by_user_id(sales.sales.salesperson_id) as salesperson_name,
    sales.sales.gift_card_id,
    sales.gift_cards.gift_card_number,
    sales.gift_cards.first_name + ' ' + sales.gift_cards.middle_name + ' ' + sales.gift_cards.last_name AS gift_card_owner,
    sales.sales.coupon_id,
    sales.coupons.coupon_code,
    sales.coupons.coupon_name,
    sales.sales.is_flat_discount,
    sales.sales.total_discount_amount,
    sales.sales.is_credit,
    sales.sales.payment_term_id,
    sales.payment_terms.payment_term_code,
    sales.payment_terms.payment_term_name,
    sales.sales.fiscal_year_code,
    sales.sales.invoice_number,
    sales.sales.total_amount,
    sales.sales.tender,
    sales.sales.change,
    sales.sales.check_number,
    sales.sales.check_date,
    sales.sales.check_bank_name,
    sales.sales.check_amount,
    sales.sales.reward_points
FROM sales.sales
INNER JOIN inventory.checkouts
ON inventory.checkouts.checkout_id = sales.sales.checkout_id
INNER JOIN finance.transaction_master
ON finance.transaction_master.transaction_master_id = inventory.checkouts.transaction_master_id
INNER JOIN finance.cash_repositories
ON finance.cash_repositories.cash_repository_id = sales.sales.cash_repository_id
INNER JOIN sales.price_types
ON sales.price_types.price_type_id = sales.sales.price_type_id
INNER JOIN inventory.counters
ON inventory.counters.counter_id = sales.sales.counter_id
INNER JOIN inventory.stores
ON inventory.stores.store_id = inventory.counters.store_id
INNER JOIN inventory.customers
ON inventory.customers.customer_id = sales.sales.customer_id
LEFT JOIN sales.gift_cards
ON sales.gift_cards.gift_card_id = sales.sales.gift_card_id
LEFT JOIN sales.payment_terms
ON sales.payment_terms.payment_term_id = sales.sales.payment_term_id
LEFT JOIN sales.coupons
ON sales.coupons.coupon_id = sales.sales.coupon_id
LEFT JOIN finance.verification_statuses
ON finance.verification_statuses.verification_status_id = finance.transaction_master.verification_status_id
WHERE finance.transaction_master.deleted = 0;


--SELECT * FROM sales.sales_view

GO


-->-->-- src/Frapid.Web/Areas/MixERP.Sales/db/SQL Server/2.x/2.0/src/99.ownership.sql --<--<--
EXEC sp_addrolemember  @rolename = 'db_owner', @membername  = 'frapid_db_user'


EXEC sp_addrolemember  @rolename = 'db_datareader', @membername  = 'report_user'


GO

