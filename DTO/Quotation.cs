﻿using System;
using System.Collections.Generic;
using Frapid.Mapper.Decorators;

namespace MixERP.Sales.DTO
{
    [TableName("sales.quotations")]
    [PrimaryKey("quotation_id")]
    public class Quotation
    {
        public long QuotationId { get; set; }
        public DateTime ValueDate { get; set; }
        public DateTime ExpectedDeliveryDate { get; set; }
        public DateTimeOffset TransactionTimestamp { get; set; }
        public int CustomerId { get; set; }
        public int PriceTypeId { get; set; }
        public int? ShipperId { get; set; }
        public int UserId { get; set; }
        public int OfficeId { get; set; }
        public string ReferenceNumber { get; set; }
        public string Terms { get; set; }
        public string InternalMemo { get; set; }
        public int AuditUserId { get; set; }
        public DateTimeOffset AuditTs { get; set; }
        public bool Deleted { get; set; }

        [Ignore]
        public List<QuotationDetail> Details { get; set; }
    }
}