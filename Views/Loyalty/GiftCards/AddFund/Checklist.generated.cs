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
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("RazorGenerator", "2.0.0.0")]
    [System.Web.WebPages.PageVirtualPathAttribute("~/Views/Loyalty/GiftCards/AddFund/Checklist.cshtml")]
    public partial class _Views_Loyalty_GiftCards_AddFund_Checklist_cshtml : System.Web.Mvc.WebViewPage<long>
    {
        public _Views_Loyalty_GiftCards_AddFund_Checklist_cshtml()
        {
        }
        public override void Execute()
        {
            
            #line 3 "..\..\Views\Loyalty\GiftCards\AddFund\Checklist.cshtml"
  
    ViewBag.Title = "Checklist";
    Layout = ViewBag.SalesLayoutPath;

            
            #line default
            #line hidden
WriteLiteral("\r\n<style>\r\n    iframe {\r\n        display: block;\r\n        margin-top: 1em;\r\n     " +
"   width: 800px;\r\n        height: 800px;\r\n        border: 1px solid #ccc;\r\n    }" +
"\r\n</style>\r\n<script");

WriteLiteral(" src=\"/Scripts/frapid/utilities/form.js\"");

WriteLiteral("></script>\r\n<div");

WriteLiteral(" class=\"ui attached page segment\"");

WriteLiteral(" style=\"min-height: 100%; padding: 3em;\"");

WriteLiteral(">\r\n    <div");

WriteLiteral(" class=\"ui huge header\"");

WriteLiteral(">Gift Card Fund Sales</div>\r\n    <div");

WriteLiteral(" class=\"ui divider\"");

WriteLiteral("></div>\r\n\r\n    <div");

WriteLiteral(" class=\"ui positive message\"");

WriteLiteral(">The transaction was posted successfully.</div>\r\n\r\n    <a");

WriteLiteral(" href=\"/dashboard/loyalty/tasks/gift-cards/add-fund\"");

WriteLiteral(" class=\"ui green button\"");

WriteLiteral(">\r\n        View Sales\r\n    </a>\r\n    <a");

WriteLiteral(" href=\"/dashboard/loyalty/tasks/gift-cards/add-fund/entry\"");

WriteLiteral(" class=\"ui red button\"");

WriteLiteral(">\r\n        Add a New Sales Entry\r\n    </a>\r\n    <iframe");

WriteAttribute("src", Tuple.Create(" src=\"", 846), Tuple.Create("\"", 957)
, Tuple.Create(Tuple.Create("", 852), Tuple.Create("/dashboard/reports/source/Areas/MixERP.Sales/Reports/GiftCardTransaction.xml?tran" +
"saction_master_id=", 852), true)
            
            #line 29 "..\..\Views\Loyalty\GiftCards\AddFund\Checklist.cshtml"
                                     , Tuple.Create(Tuple.Create("", 951), Tuple.Create<System.Object, System.Int32>(Model
            
            #line default
            #line hidden
, 951), false)
);

WriteLiteral("></iframe>\r\n</div>\r\n\r\n\r\n<script>\r\n    window.overridePath = \"/dashboard/sales/tas" +
"ks/entry\";\r\n</script>");

        }
    }
}
#pragma warning restore 1591
