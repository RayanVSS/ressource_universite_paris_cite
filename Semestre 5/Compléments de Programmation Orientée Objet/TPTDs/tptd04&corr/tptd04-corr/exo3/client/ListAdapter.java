package client;

import stats.DataSeries;

import java.util.List;

public class ListAdapter implements DataSeries {
    private final List<Double> proxy;


    public ListAdapter(List<Double> proxy) {
        this.proxy = proxy;
    }

    @Override
    public double read(int i) {
        return proxy.get(i);
    }

    @Override
    public int length() {
        return proxy.size();
    }
}
