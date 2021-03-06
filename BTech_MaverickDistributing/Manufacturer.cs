//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace BTech_MaverickDistributing
{
    using System;
    using System.Collections.Generic;
    
    public partial class Manufacturer
    {
        public Manufacturer()
        {
            this.Parts = new HashSet<Part>();
        }
    
        public int ManufacturerTypeID { get; set; }
        public string ManufacturerName { get; set; }
        public string ManufacturerDesc { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public int ManufacturerID { get; set; }
    
        public virtual ManufacturerType ManufacturerType { get; set; }
        public virtual ICollection<Part> Parts { get; set; }
    }
}
