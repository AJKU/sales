﻿#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ASP
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Text;
    using System.Web;
    using System.Web.Helpers;
    using System.Web.Mvc;
    using System.Web.Mvc.Ajax;
    using System.Web.Mvc.Html;
    using System.Web.Routing;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.WebPages;
    using Frapid.Configuration;
    using Frapid.Dashboard;
    using Frapid.DataAccess;
    using Frapid.DbPolicy;
    using Frapid.Framework;
    using Frapid.i18n;
    using Frapid.Messaging;
    using Frapid.NPoco;
    using Frapid.WebsiteBuilder;
    using MixERP.Sales;
    
    #line 1 "..\..\Views\Loyalty\GiftCards\AddFund\Entry.cshtml"
    using MixERP.Sales.Extensions;
    
    #line default
    #line hidden
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("RazorGenerator", "2.0.0.0")]
    [System.Web.WebPages.PageVirtualPathAttribute("~/Views/Loyalty/GiftCards/AddFund/Entry.cshtml")]
    public partial class _Views_Loyalty_GiftCards_AddFund_Entry_cshtml : System.Web.Mvc.WebViewPage<dynamic>
    {
        public _Views_Loyalty_GiftCards_AddFund_Entry_cshtml()
        {
        }
        public override void Execute()
        {
            
            #line 4 "..\..\Views\Loyalty\GiftCards\AddFund\Entry.cshtml"
  
    ViewBag.Title = "Add Fund to Gift Cards";
    Layout = ViewBag.SalesLayoutPath;

            
            #line default
            #line hidden
WriteLiteral("\r\n\r\n<style>\r\n    iframe {\r\n        border: 1px solid #ccc;\r\n        width: 500px;" +
"\r\n        height: 800px;\r\n        margin: 0 auto;\r\n        padding: 1em;\r\n    }\r" +
"\n</style>\r\n<script");

WriteLiteral(" src=\"/Scripts/frapid/utilities/form.js\"");

WriteLiteral("></script>\r\n<script");

WriteLiteral(" src=\"/Scripts/frapid/utilities/validator.js\"");

WriteLiteral("></script>\r\n<div");

WriteLiteral(" class=\"ui attached gift card fund segment\"");

WriteLiteral(" style=\"padding: 3em\"");

WriteLiteral(">\r\n    <div");

WriteLiteral(" class=\"ui container\"");

WriteLiteral(">\r\n        <div");

WriteLiteral(" class=\"ui large header\"");

WriteLiteral(">Add Funds To Gift Card</div>\r\n        <div");

WriteLiteral(" class=\"ui divider\"");

WriteLiteral("></div>\r\n        <div");

WriteLiteral(" class=\"ui form\"");

WriteLiteral(" style=\"width: 500px;\"");

WriteLiteral(">\r\n            <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                <label>Enter Gift Card Number</label>\r\n                <div");

WriteLiteral(" class=\"ui action input\"");

WriteLiteral(">\r\n                    <input");

WriteLiteral(" id=\"GiftCardNumberInputText\"");

WriteLiteral(" required=\"\"");

WriteLiteral(" type=\"text\"");

WriteLiteral(">\r\n                    <button");

WriteLiteral(" class=\"ui icon blue button\"");

WriteLiteral(" onclick=\'$(\".ui.gift.card.modal\").modal(\"show\");\'");

WriteLiteral(">\r\n                        <i");

WriteLiteral(" class=\"search icon\"");

WriteLiteral("></i>\r\n                    </button>\r\n                </div>\r\n            </div>\r" +
"\n            <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                <label>Enter Amount</label>\r\n                <input");

WriteLiteral(" id=\"AmountInputText\"");

WriteLiteral(" type=\"text\"");

WriteLiteral(" class=\"decimal\"");

WriteLiteral(" required=\"\"");

WriteLiteral(" />\r\n            </div>\r\n            <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                <label>Select Debit Account</label>\r\n                <select");

WriteLiteral(" id=\"AccountIdSelect\"");

WriteLiteral(" class=\"ui search dropdown\"");

WriteLiteral(" required=\"\"");

WriteLiteral("></select>\r\n            </div>\r\n            <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                <label>Value Date</label>\r\n                <input");

WriteLiteral(" type=\"text\"");

WriteLiteral(" class=\"date\"");

WriteLiteral(" required=\"\"");

WriteLiteral(" id=\"ValueDateInputText\"");

WriteLiteral(" />\r\n            </div>\r\n            <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                <label>Book Date</label>\r\n                <input");

WriteLiteral(" type=\"text\"");

WriteLiteral(" class=\"date\"");

WriteLiteral(" required=\"\"");

WriteLiteral(" id=\"BookDateInputText\"");

WriteLiteral(" />\r\n            </div>\r\n            <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                <label>Select Cost Center</label>\r\n                <select");

WriteLiteral(" id=\"CostCenterIdSelect\"");

WriteLiteral(" class=\"ui search dropdown\"");

WriteLiteral(" required=\"\"");

WriteLiteral("></select>\r\n            </div>\r\n            <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                <label>Reference Number</label>\r\n                <input");

WriteLiteral(" type=\"text\"");

WriteLiteral(" id=\"ReferenceNumberInputText\"");

WriteLiteral(" />\r\n            </div>\r\n            <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                <label>Memo</label>\r\n                <input");

WriteLiteral(" type=\"text\"");

WriteLiteral(" id=\"StatementReferenceInputText\"");

WriteLiteral(" />\r\n            </div>\r\n\r\n            <button");

WriteLiteral(" id=\"SaveButton\"");

WriteLiteral(" class=\"ui positive circular button\"");

WriteLiteral(">Save</button>\r\n            <a");

WriteLiteral(" href=\"/dashboard/loyalty/tasks/gift-cards/add-fund/\"");

WriteLiteral(" class=\"ui negative circular button\"");

WriteLiteral(">Back</a>\r\n        </div>\r\n    </div>\r\n</div>\r\n\r\n");

            
            #line 69 "..\..\Views\Loyalty\GiftCards\AddFund\Entry.cshtml"
Write(Html.PartialView("Shared/GiftCardSerachModal.cshtml", TenantConvention.GetTenant()));

            
            #line default
            #line hidden
WriteLiteral(";\r\n\r\n<script>\r\n    function loadAccounts() {\r\n        \r\n        const filters = [" +
"];\r\n        filters.push(window.getAjaxColumnFilter(\"WHERE\", \"account_master_id\"" +
", \"int\", window.FilterConditions.IsEqualTo, \"10101\"));//CASH\r\n        filters.pu" +
"sh(window.getAjaxColumnFilter(\"OR\", \"account_master_id\", \"int\", window.FilterCon" +
"ditions.IsEqualTo, \"10102\"));//BANK\r\n        filters.push(window.getAjaxColumnFi" +
"lter(\"OR\", \"account_master_id\", \"int\", window.FilterConditions.IsEqualTo, \"10110" +
"\"));//ACCOUNT RECEIVABLE\r\n\r\n        window.displayFieldBinder($(\"#AccountIdSelec" +
"t\"), \"/api/forms/finance/accounts/display-fields/get-where\", true, filters);\r\n  " +
"  };\r\n\r\n    function loadCostCenters() {\r\n        window.displayFieldBinder($(\"#" +
"CostCenterIdSelect\"), \"/api/forms/finance/cost-centers/display-fields\", true);\r\n" +
"    };\r\n\r\n    loadCostCenters();\r\n    loadAccounts();\r\n\r\n</script>\r\n<script>\r\n  " +
"  var segment = $(\".gift.card.fund.segment\");\r\n\r\n    window.validator.initialize" +
"(segment);\r\n\r\n    $(\"#SaveButton\").unbind(\"click\").bind(\"click\", function () {\r\n" +
"        function request(model) {\r\n            const url = \"/dashboard/loyalty/t" +
"asks/gift-cards/add-fund/entry\";\r\n            const data = JSON.stringify(model)" +
";\r\n            return window.getAjaxRequest(url, \"POST\", data);\r\n        };\r\n\r\n " +
"       function getModel() {\r\n            const model = window.serializeForm(seg" +
"ment);\r\n            return model;\r\n        };\r\n\r\n        const isValid = window." +
"validator.validate($(\".ui.form\"));\r\n        if (!isValid) {\r\n            return;" +
"\r\n        };\r\n\r\n        const model = getModel();\r\n\r\n        const ajax = reques" +
"t(model);\r\n\r\n        ajax.success(function (response) {\r\n            const id = " +
"response;\r\n            const url = \"/dashboard/loyalty/tasks/gift-cards/add-fund" +
"/checklist/\" + id;\r\n\r\n            window.location = url;\r\n        });\r\n\r\n       " +
" ajax.fail(function (xhr) {\r\n            window.logAjaxErrorMessage(xhr);\r\n     " +
"   });\r\n    });\r\n\r\n    window.overridePath = \"/dashboard/loyalty/tasks/gift-card" +
"s/add-fund\";\r\n</script>");

        }
    }
}
#pragma warning restore 1591
