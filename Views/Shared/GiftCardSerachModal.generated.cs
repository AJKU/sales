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
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("RazorGenerator", "2.0.0.0")]
    [System.Web.WebPages.PageVirtualPathAttribute("~/Views/Shared/GiftCardSerachModal.cshtml")]
    public partial class _Views_Shared_GiftCardSerachModal_cshtml : System.Web.Mvc.WebViewPage<dynamic>
    {
        public _Views_Shared_GiftCardSerachModal_cshtml()
        {
        }
        public override void Execute()
        {
WriteLiteral("<div");

WriteLiteral(" class=\"ui large find gift card modal\"");

WriteLiteral(">\r\n    <i");

WriteLiteral(" class=\"close icon\"");

WriteLiteral("></i>\r\n    <div");

WriteLiteral(" class=\"header\"");

WriteLiteral(">Search Gift Card</div>\r\n    <div");

WriteLiteral(" class=\"content\"");

WriteLiteral(" style=\"padding:3em\"");

WriteLiteral(">\r\n        <div");

WriteLiteral(" class=\"ui search form\"");

WriteLiteral(">\r\n            <div");

WriteLiteral(" class=\"two fields\"");

WriteLiteral(">\r\n                <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                    <label>Phone</label>\r\n                    <input");

WriteLiteral(" type=\"tel\"");

WriteLiteral(" name=\"PhoneInputText\"");

WriteLiteral(" />\r\n                </div>\r\n                <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                    <label>Name</label>\r\n                    <input");

WriteLiteral(" type=\"text\"");

WriteLiteral(" name=\"NameInputText\"");

WriteLiteral(" />\r\n                </div>\r\n            </div>\r\n            <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                <label>Address</label>\r\n                <input");

WriteLiteral(" type=\"text\"");

WriteLiteral(" name=\"AddressInputText\"");

WriteLiteral(" />\r\n            </div>\r\n            <div");

WriteLiteral(" class=\"three fields\"");

WriteLiteral(">\r\n                <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                    <label>City</label>\r\n                    <input");

WriteLiteral(" type=\"text\"");

WriteLiteral(" name=\"CityInputText\"");

WriteLiteral(" />\r\n                </div>\r\n                <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                    <label>State</label>\r\n                    <input");

WriteLiteral(" type=\"text\"");

WriteLiteral(" name=\"StateInputText\"");

WriteLiteral(" />\r\n                </div>\r\n                <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                    <label>Country</label>\r\n                    <input");

WriteLiteral(" type=\"text\"");

WriteLiteral(" name=\"CountryInputText\"");

WriteLiteral(" />\r\n                </div>\r\n            </div>\r\n            <div");

WriteLiteral(" class=\"two fields\"");

WriteLiteral(">\r\n                <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                    <label>ZIP Code</label>\r\n                    <input");

WriteLiteral(" type=\"text\"");

WriteLiteral(" name=\"ZipcodeInputText\"");

WriteLiteral(" />\r\n                </div>\r\n                <div");

WriteLiteral(" class=\"field\"");

WriteLiteral(">\r\n                    <label>PO Box</label>\r\n                    <input");

WriteLiteral(" type=\"text\"");

WriteLiteral(" name=\"PoBoxInputText\"");

WriteLiteral(" />\r\n                </div>\r\n            </div>\r\n\r\n            <div");

WriteLiteral(" id=\"SearchButton\"");

WriteLiteral(" class=\"ui positive circular button\"");

WriteLiteral(">Search</div>\r\n        </div>\r\n\r\n        <table");

WriteLiteral(" class=\"ui results table\"");

WriteLiteral(">\r\n            <thead>\r\n            <tr>\r\n                <th>Select</th>\r\n      " +
"          <th>Gift Card #</th>\r\n                <th>Name</th>\r\n                <" +
"th>Phone</th>\r\n                <th>Address</th>\r\n                <th>City</th>\r\n" +
"                <th>State</th>\r\n                <th>Country</th>\r\n              " +
"  <th>ZIP Code</th>\r\n                <th>PO Box</th>\r\n            </tr>\r\n       " +
"     </thead>\r\n            <tbody>\r\n            \r\n            </tbody>\r\n        " +
"</table>\r\n    </div>\r\n</div>\r\n\r\n<script>\r\n    function showSearchResult(id) {\r\n " +
"       $(\"#GiftCardNumberInputText\").val(id).trigger(\"change\").trigger(\"blur\");\r" +
"\n        $(\".ui.gift.card.modal\").modal(\"hide\");\r\n    };\r\n\r\n    $(\"#SearchButton" +
"\").unbind(\"click\").bind(\"click\", function () {\r\n        function displayResult(m" +
"odel) {\r\n            function getCell(html) {\r\n                const cell = $(\"<" +
"td />\");\r\n                cell.html(html);\r\n                return cell;\r\n      " +
"      };\r\n\r\n            function getActionCell(id) {\r\n                var html =" +
" \"<a onclick=\'showSearchResult(\\\"{id}\\\");\'>Select</a>\";\r\n                html = " +
"html.replace(\"{id}\", id);\r\n\r\n                const cell = $(\"<td />\");\r\n        " +
"        cell.html(html);\r\n                return cell;\r\n            };\r\n\r\n      " +
"      var target = $(\".results.table tbody\").html(\"\");\r\n\r\n            $.each(mod" +
"el, function () {\r\n                const row = $(\"<tr />\");\r\n                row" +
".append(getActionCell(this.GiftCardNumber));\r\n                row.append(getCell" +
"(this.GiftCardNumber));\r\n                row.append(getCell(this.Name));\r\n      " +
"          row.append(getCell(this.PhoneNumbers));\r\n                row.append(ge" +
"tCell(this.Address));\r\n                row.append(getCell(this.City));\r\n        " +
"        row.append(getCell(this.State));\r\n                row.append(getCell(thi" +
"s.Country));\r\n                row.append(getCell(this.Zipcode));\r\n              " +
"  row.append(getCell(this.PoBox));\r\n\r\n                target.append(row);\r\n     " +
"       });\r\n        };\r\n\r\n        function request(model) {\r\n            const u" +
"rl = \"/dashboard/loyalty/tasks/gift-cards/search\";\r\n            const data = JSO" +
"N.stringify(model);\r\n\r\n            return window.getAjaxRequest(url, \"POST\", dat" +
"a);\r\n        }\r\n\r\n        const model = window.serializeForm($(\".ui.search.form\"" +
"));\r\n\r\n        const ajax = request(model);\r\n\r\n        ajax.success(function (re" +
"sponse) {\r\n            displayResult(response);\r\n        });\r\n\r\n        ajax.fai" +
"l(function (xhr) {\r\n            window.logAjaxErrorMessage(xhr);\r\n        });\r\n " +
"   });\r\n</script>");

        }
    }
}
#pragma warning restore 1591
