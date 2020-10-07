class Calculator{
  double _value = 0.0;
  
    void add(double x) {
      _value += x;
    }
    void multiply(double x) {
      _value *= x;
    }
    double getValue() {
        return _value;
    }
}
