namespace ProduccionBack.Models
{
    public class ParameterSQL
    {
        public ParameterSQL(string name, object value)
        {
            Name = name;
            Value = value;
        }
        public string Name { get; set; }
        public object Value { get; set; }
    }
}
