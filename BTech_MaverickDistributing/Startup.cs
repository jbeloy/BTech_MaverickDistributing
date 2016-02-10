using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(BTech_MaverickDistributing.Startup))]
namespace BTech_MaverickDistributing
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
