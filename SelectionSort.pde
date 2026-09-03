int[] list = new int[100000];
int i, j, tmp;

for(i=0; i<list.length; i++) {
  list[i] = (int)random(1000);
}
println(list.length);

for (i=0; i<list.length -1; i++) {
  for (j=i+1; j<list.length; j++) {
    if (list[i] > list[j]) {
      tmp = list[i];
      list[i] = list[j];
      list[j] = tmp;
    }
  }
}

println(list);
line(0,0, 100,100);
