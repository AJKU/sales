using System;
using System.Net;
using System.Threading.Tasks;
using System.Web.Mvc;
using Frapid.Areas;
using Frapid.Dashboard;
using MixERP.Sales.DAL.Backend.Service;
using MixERP.Sales.ViewModels;

namespace MixERP.Sales.Controllers.Backend.Tasks
{
    public class CustomerSearchController : FrapidController
    {
        [Route("dashboard/sales/setup/customers/search")]
        [MenuPolicy(OverridePath = "/dashboard/sales/tasks/entry")]
        public ActionResult Index()
        {
            return this.View("/Areas/MixERP.Sales/Views/Setup/CustomerSearch.cshtml");
        }

        [Route("dashboard/sales/setup/customer/search/{query}")]
        public async Task<ActionResult> SearchCustomerAsync(string query)
        {
            try
            {
                var result = await Customers.SearchAsync(this.Tenant, query.Replace("\\", "").Trim()).ConfigureAwait(false);
                var model = new CustomerSearchViewModel
                {
                    Items = result
                };

                return this.Ok(model);
            }
            catch (Exception ex)
            {
                return this.Failed(ex.Message, HttpStatusCode.InternalServerError);
            }
        }
    }
}