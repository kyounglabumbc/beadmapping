% lines 83-108

% generate gaussian peaks

g_peaks = zeros(3,3,7,7);

for k = 1:2 
    for l = 1:2 
       offx = 0.5*(k-1);
       offy = 0.5*(l-1);
       for i = 1:6
         for j = 1:6
          dist = 0.4 * ((i-3.0+offx)^2 + (j-3.0+offy)^2);
          g_peaks(k,l,i,j) = exp(-dist);
         end
       end
    end
end

good = zeros(2,10000);
back = zeros(10000,:);
foob = zeros(7,7);
diff = zeros(3,3);



%SKIP 110-125



film_x = 1;
film_y = 1;
fr_no  = 1;