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
    [System.Web.WebPages.PageVirtualPathAttribute("~/Views/Setup/CustomerSearch.cshtml")]
    public partial class _Views_Setup_CustomerSearch_cshtml : System.Web.Mvc.WebViewPage<dynamic>
    {
        public _Views_Setup_CustomerSearch_cshtml()
        {
        }
        public override void Execute()
        {
            
            #line 3 "..\..\Views\Setup\CustomerSearch.cshtml"
  
    ViewBag.Title = "Customers";
    Layout = ViewBag.SalesLayoutPath;

            
            #line default
            #line hidden
WriteLiteral("\r\n\r\n<!DOCTYPE html>\r\n<html>\r\n<head>\r\n    <title>Customers</title>\r\n    <meta");

WriteLiteral(" charset=\"utf-8\"");

WriteLiteral(" />\r\n    <script");

WriteLiteral(" src=\"/i18n/resources.js\"");

WriteLiteral("></script>\r\n    <script");

WriteLiteral(" src=\"/assets/js/backend.js\"");

WriteLiteral("></script>\r\n    <script");

WriteLiteral(" src=\"/Scripts/inflection-js/inflection.js\"");

WriteLiteral("></script>\r\n    <script");

WriteLiteral(" src=\"/Scripts/frapid/utilities/localizable.js\"");

WriteLiteral("></script>\r\n    <script");

WriteLiteral(" src=\"/Scripts/frapid/utilities/validator.js\"");

WriteLiteral("></script>\r\n    <link");

WriteLiteral(" rel=\"stylesheet\"");

WriteLiteral(" type=\"text/css\"");

WriteLiteral(" href=\"/Scripts/semantic-ui/semantic.min.css\"");

WriteLiteral(" />\r\n    <link");

WriteLiteral(" rel=\"stylesheet\"");

WriteLiteral(" type=\"text/css\"");

WriteLiteral(" href=\"/dashboard/my/template/Contents/dashboard.css\"");

WriteLiteral("/>\r\n    <style>\r\n        html, body {\r\n            font-size: 12px;\r\n        }\r\n " +
"   </style>\r\n</head>\r\n<body>\r\n\r\n    <script>\r\n        var scrudFactory = new Obj" +
"ect();\r\n\r\n        scrudFactory.title = \"Customers\";\r\n\r\n        scrudFactory.view" +
"API = \"/api/views/inventory/customer-scrud-view\";\r\n        scrudFactory.viewTabl" +
"eName = \"inventory.customers\";\r\n\r\n        scrudFactory.formAPI = \"/api/forms/inv" +
"entory/customers\";\r\n        scrudFactory.formTableName = \"inventory.customers\";\r" +
"\n\r\n        scrudFactory.excludedColumns = [\"audit_user_id\", \"audit_ts\"];\r\n\r\n    " +
"    scrudFactory.allowDelete = true;\r\n        scrudFactory.allowEdit = true;\r\n\r\n" +
"        scrudFactory.live = \"CustomerName\";\r\n\r\n        //scrudFactory.card = {\r\n" +
"        //    header: \"\",\r\n        //    description: \"\",\r\n        //    image: " +
"\"\"\r\n        //};\r\n\r\n        scrudFactory.layout = [\r\n            {\r\n            " +
"    tab: \"\",\r\n                fields: [\r\n                    [\"CustomerId\", \"\"]," +
"\r\n                    [\"Photo\", \"\"],\r\n                    [\"CustomerCode\", \"Cust" +
"omerName\"],\r\n                    [\"CustomerTypeId\", \"\"],\r\n                    [\"" +
"Logo\", \"\"]\r\n                ]\r\n            }\r\n        ];\r\n\r\n        scrudFactory" +
".keys = [\r\n            {\r\n                property: \"CustomerTypeId\",\r\n         " +
"       url: \'/api/forms/inventory/customer-types/display-fields\',\r\n             " +
"   data: null,\r\n                valueField: \"Key\",\r\n                textField: \"" +
"Value\"\r\n            }\r\n        ];\r\n\r\n\r\n        var selectButton = $(\"<button cla" +
"ss=\'ui basic button\' id=\'SelectButton\'>Select & Close</button>\");\r\n        var u" +
"seButton = $(\"<button class=\'ui blue button\' id=\'UseButton\'>Use</button>\");\r\n   " +
"     var scrudSaveButtonCallback = undefined;\r\n\r\n        $.get(\'/ScrudFactory/Vi" +
"ew.html\', function (view) {\r\n            $.get(\'/ScrudFactory/Form.html\', functi" +
"on (form) {\r\n                $(\"#ScrudFactoryView\").html(view);\r\n               " +
" $(\"#ScrudFactoryForm\").html(form);\r\n\r\n                $(\".filter.column\").hide(" +
");\r\n                $(\".scrud-grid.column\").removeClass(\"thirteen wide\").addClas" +
"s(\"sixteen wide\");\r\n\r\n\r\n                $(\"#AddNewButton\").after(selectButton);\r" +
"\n                $(\"#SaveButton\").before(useButton);\r\n\r\n                $.cached" +
"Script(\"/assets/js/scrudfactory-view.js\");\r\n                $.cachedScript(\"/ass" +
"ets/js/scrudfactory-form.js\");\r\n            });\r\n        });\r\n\r\n        selectBu" +
"tton.click(function() {\r\n            const customerId = window.getSelected();\r\n " +
"           const tr = $(\"table#ScrudView input:checkbox:checked\").first().closes" +
"t(\"tr\");\r\n            const customerCode = tr.find(\"td:eq(3)\").html();\r\n\r\n      " +
"      parent.onCustomerSearchSelect(customerId, customerCode);\r\n        });\r\n\r\n " +
"       useButton.click(function () {\r\n            scrudSaveButtonCallback = func" +
"tion (customerId) {\r\n                const parent = window.parent;\r\n            " +
"    parent.onCustomerSearchSelect(customerId);\r\n            };\r\n\r\n            $(" +
"\"#SaveButton\").trigger(\"click\");\r\n        });\r\n\r\n    </script>\r\n\r\n    <div");

WriteLiteral(" id=\"ScrudFactoryForm\"");

WriteLiteral("></div>\r\n    <div");

WriteLiteral(" id=\"ScrudFactoryView\"");

WriteLiteral("></div>\r\n</body>\r\n</html>\r\n");

        }
    }
}
#pragma warning restore 1591
