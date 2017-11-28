public final static class GeneralCalc {
    /**
     指定した座標同士のラジアン角を返す。
     座標2から座標1に向けての角度になるので注意。
     */
    public static float GetRad(float x1, float y1, float x2, float y2) {
        float y, x;
        y = y1 - y2;
        x = x1 - x2;
        if (y == 0 && x == 0) return 0;
        float a = atan(y/x);
        if (x < 0) a += PI;
        return a;
    }

    /**
     配列のソートを行う。
     ただし、格納されているオブジェクトがComparableインタフェースを実装していることを前提とする。
     */
    public static void Sort(Comparable[] o) {
        if (o == null) return;
        _QuickSort(o, 0, o.length-1);
    }

    /**
     リストのソートを行う。
     ただし、格納されているオブジェクトがComparableインタフェースを実装していることを前提とする。
     */
    public static void Sort(ArrayList<Comparable> o) {
        if (o == null) return;
        _QuickSort(o, 0, o.size()-1);
    }

    /**
     軸要素の選択
     順に見て、最初に見つかった異なる2つの要素のうち、
     大きいほうの番号を返します。
     全部同じ要素の場合は -1 を返します。
     */
    private static int _Pivot(Comparable[] o, int i, int j) {
        int k = i+1;
        while (k <= j && o[i].compareTo(o[k]) == 0) k++;
        if (k > j) return -1;
        if (o[i].compareTo(o[k]) >= 0) return i;
        return k;
    }

    private static int _Pivot(ArrayList<Comparable> o, int i, int j) {
        int k = i+1;
        while (k <= j && o.get(i).compareTo(o.get(k)) == 0) k++;
        if (k > j) return -1;
        if (o.get(i).compareTo(o.get(k)) >= 0) return i;
        return k;
    }

    /**
     クイックソート
     配列oの、o[i]からo[j]を並べ替えます。
     */
    private static void _QuickSort(Comparable[] o, int i, int j) {
        if (i == j) return;
        int p = _Pivot(o, i, j);
        if (p != -1) {
            int k = _Partition(o, i, j, o[p]);
            _QuickSort(o, i, k-1);
            _QuickSort(o, k, j);
        }
    }

    private static void _QuickSort(ArrayList<Comparable> o, int i, int j) {
        if (i == j) return;
        int p = _Pivot(o, i, j);
        if (p != -1) {
            int k = _Partition(o, i, j, o.get(p));
            _QuickSort(o, i, k-1);
            _QuickSort(o, k, j);
        }
    }

    /**
     パーティション分割
     o[i]～o[j]の間で、x を軸として分割します。
     x より小さい要素は前に、大きい要素はうしろに来ます。
     大きい要素の開始番号を返します。
     */
    private static int _Partition(Comparable[] o, int i, int j, Comparable x) {
        int l=i, r=j;
        // 検索が交差するまで繰り返します
        while (l<=r) {
            // 軸要素以上のデータを探します
            while (l<=j && o[l].compareTo(x) < 0)  l++;
            // 軸要素未満のデータを探します
            while (r>=i && o[r].compareTo(x) >= 0) r--;
            if (l>r) break;
            Comparable t=o[l];
            o[l]=o[r];
            o[r]=t;
            l++; 
            r--;
        }
        return l;
    }

    private static int _Partition(ArrayList<Comparable> o, int i, int j, Comparable x) {
        int l=i, r=j;
        while (l<=r) {
            while (l<=j && o.get(l).compareTo(x) < 0)  l++;
            while (r>=i && o.get(r).compareTo(x) >= 0) r--;
            if (l>r) break;
            Comparable t=o.get(l);
            o.set(l, o.get(r));
            o.set(r, t);
            l++; 
            r--;
        }
        return l;
    }
}