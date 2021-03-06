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
    using Frapid.Mapper.Decorators;
    using Frapid.WebsiteBuilder;
    using MixERP.Sales;
    
    #line 1 "..\..\Views\Tasks\Entry\Index.cshtml"
    using MixERP.Sales.Extensions;
    
    #line default
    #line hidden
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("RazorGenerator", "2.0.0.0")]
    [System.Web.WebPages.PageVirtualPathAttribute("~/Views/Tasks/Entry/Index.cshtml")]
    public partial class _Views_Tasks_Entry_Index_cshtml : System.Web.Mvc.WebViewPage<dynamic>
    {
        public _Views_Tasks_Entry_Index_cshtml()
        {
        }
        public override void Execute()
        {
            
            #line 4 "..\..\Views\Tasks\Entry\Index.cshtml"
  
    ViewBag.Title = "Sales Entries";
    Layout = ViewBag.SalesLayoutPath;

            
            #line default
            #line hidden
WriteLiteral("\r\n\r\n");

            
            #line 9 "..\..\Views\Tasks\Entry\Index.cshtml"
Write(Html.FinancePartialView("Shared/JournalView.cshtml", TenantConvention.GetTenant()));

            
            #line default
            #line hidden
WriteLiteral("\r\n\r\n<script>\r\n    window.prepareView({\r\n        Title: \"Sales\",\r\n        AddNewTe" +
"xt: \"Add New\",\r\n        AddNewUrl: \"/dashboard/sales/tasks/entry/new\",\r\n        " +
"ReturnText: \"Return\",\r\n        ReturnUrl: \"javascript:void(0);\",\r\n        Book: " +
"\"Sales Entry\",\r\n        ChecklistUrl: \"/dashboard/sales/tasks/entry/checklist/{t" +
"ranId}\",\r\n        AdviceButtons: [\r\n            {\r\n                Title: \"View " +
"Sales Invoice\",\r\n                Href: \"javascript:void(0);\",\r\n                O" +
"nClick: \"showInvoice({tranId});\"\r\n            }\r\n        ]\r\n    });\r\n\r\n    $(\"#R" +
"eturnButton\").click(function () {\r\n        function getSelectedItem() {\r\n       " +
"     const selected = $(\"#JournalView\").find(\"input:checked\").first();\r\n\r\n      " +
"      if (selected.length) {\r\n                const row = selected.parent().pare" +
"nt().parent();\r\n                const id = row.find(\"td:nth-child(3)\").html();\r\n" +
"                return parseInt(id);\r\n            };\r\n\r\n            return 0;\r\n " +
"       };\r\n\r\n        const selected = getSelectedItem();\r\n        if (selected) " +
"{\r\n            const url = \"/dashboard/sales/tasks/return/new?Type=Return&Transa" +
"ctionMasterId=\" + selected;\r\n            document.location = url;\r\n            r" +
"eturn;\r\n        };\r\n\r\n        window.displayMessage(\"Please select an item from " +
"the grid.\");\r\n    });\r\n\r\n    function showInvoice(tranId) {\r\n        $(\".advice." +
"modal iframe\").attr(\"src\", \"/dashboard/reports/source/Areas/MixERP.Sales/Reports" +
"/Invoice.xml?transaction_master_id=\" + tranId);\r\n\r\n        setTimeout(function (" +
") {\r\n            $(\".advice.modal\")\r\n                .modal(\'setting\', \'transiti" +
"on\', \'horizontal flip\')\r\n                .modal(\"show\");\r\n\r\n        }, 300);\r\n  " +
"  };\r\n</script>");

        }
    }
}
#pragma warning restore 1591
