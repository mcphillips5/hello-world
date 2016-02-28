function[a,b] = findbracket(f,x0);
k = 1;
while not((x0 - 2^(-k)) == x0); %%mechanically finds the distance to the next machine number, cooler than eps(x)
    k = k + 1;
    if ((x0 - 2^(-k)) == x0);
        d = 2^(-k + 1); %%identifies the point where del makes fl indistinguishable, then we go one behind it
    end %% need to use 
end
a = x0;
b = x0;
while sign(f(a)) == sign(f(b)); %%this slowly opens our interval until the interval brackets a zero.
    a = a - d;
    b = b + d;
    d = 2*d;
end
[a,b]
end
%%this question didn't have too many design decisions. I guess just whether
%%to use eps(x) or a while loop to find the original del.
%%strain told us that we only need to consider functions that will be
%%bracketed, and only cases where there IS a root and it's a simple root.
%%Strain posted most of the pseudo-code in the project desription, so there
%%wasn't too much free range for me.

%%similarly, it coincidents pretty well with theory. It works when it
%%should, meaning  when theres a sign change and a simple root, it goes
%%right to it, and with decent speed.