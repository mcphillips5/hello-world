function [r, h] = schroderbisection(a, b, f, fp, fpp, tol) %%Assume originial case brackets root: Strain said so!
cr = 0; %%counter for use with matrix later to eliminate the all 0 case.
h = [0;0;0;0;0;0]; %%initializes our history matrix
%%the following two if statements check the trivial case: if one
%%of our original endpoints is a zero.
if f(a) == 0; 
    r = a; %%our approximation would be exactly that value. we'd be done!
    h = [a;0;0;0;b;0];%% making a change
return
end
if f(b) == 0;
    r = b;
    h = [a;0;0;0;b;0]; 
return
end
while (b-a)/2 > tol && not(b == a + eps(a));  %%two sentinel variables, parameters for stopping given by strain
    cr = cr + 1; %%a counter to be used later in the history matrix
    if a == 0;%% accounting for if a is zero, so we don't get trouble later on.
        a = realmin; %this is okay, since we checked if 'a' gave a zero and it didn't
    elseif b == 0;%% accounting for if b is zero, so we don't get an error.since b is a right endpoint we shorten by moving it left.
        b = -realmin;%% this is okay for the same reason.
    end
     if a < 0 && b > 0 %%given by strain, so we dont take square root of a negative number,
        p = realmin;
    else
        p = sign(a)*(abs(a))^(0.5) * abs((b))^(0.5); %%the general case. roots them individually to avoid overflow issues
     end%% also using absolute value, this works for if a,b both negative or a,b both positive
    ee = min(abs(f(b)-f(a))/8,abs(fpp(p))*abs(b-a)^2);
    qp = @(x) x - ((f(x)+ ee) *fp(x))/((fp(x))^2-(f(x)+ee)*fpp(x));
    qm = @(x) x - ((f(x)- ee) *fp(x))/((fp(x))^2-(f(x)-ee)*fpp(x));
    %%finding our 5 contestants to see who the new interval will be,
    %%testing to see if each is bracketed, and then out of those, who the
    %%min is.
    %% this part just sets up my 5 values to be called later
    v(1) = p;
    v(2) = a;%renaming my variables to be called upon later
    v(3) = b;
    v(4) = qp(p);
    v(5) = qm(p);
    %%this controls for if " one f values vanishes exactly"
    %%if it does, we assign the interval to be just the point. This means
    %%we win! and return that result
    for i = 1:5;
        if f(v(i)) == 0;
            a = v(i);
            b = v(i);
            r = a;
            if cr == 1
                h = [a;p;v(4);v(5);b;f(p)];
            else
                helper = [a;p;v(4);v(5);b;f(p)];
                h = cat(2,h,helper);
            end
            return
        end;
    end;
    %%this ranslates our 5 contestance into 25 different pairs, 
    %%(only need 10 since 5Choose2 though, but we'll deal with that later)
    %% it has 1st column as a value and 2nd column as b value
    for i = 1:5; 
        for j = 1:5;
            C(j+5*(i-1),1)= v(i);
            C(j+5*(i-1),2) = v(j);
        end
    end
    %%now that the cell array with all combinations is built, we need to
    %%take out some things, namely the same pairs (a,a) (b,b),etc. and
    %%the reoorderings,
    %%since (a,b) = (b,a), and finally the ones which aren't bracketed.
    %%we add a third column to C for our distance!
    for k = 1:25;
        C(k,3) = abs(C(k,1)-C(k,2));
        if C(k,1) >= C(k,2); %eliminates pairs and reoorderings
            C(k,3) = inf; %%set the bad ones to infinity, to be sorted out later
        elseif sign(f(C(k,1))) == sign(f(C(k,2)));%%eliminates non-bracketed pairs
            C(k,3) = inf;
        end
    end
     %%We now check each pair to find the minimum distance, since the
     %%unbracketed, duplicates, and re-orderings were disqualified by setting their distance to infinity.
     L = inf; %%initializes our minimum distance
    for k = 1:25;
        if C(k,3) < L;
            L = min(L, C(k,3));
            KK = k; %%the index of the minimum distance, we'll figure out its points later.
        end
    end
    if cr == 1 %%if its the first iteration, we replace the zero matrix with our current points
        h = [a;p;v(4);v(5);b;f(p)];
    else %if its any other iteration just add a new column to our old matrix
        helper = [a;p;v(4);v(5);b;f(p)]; %%this saves our 5 values for this iteration in a column
        h = cat(2,h,helper);%this will adjoin our new column with our old matrix at each iteration
    end 
    a = C(KK,1); %%this retrieves the left endpoint of the pair with lowest distance
    b = C(KK,2); %%this retrieves the right endpoint of the pair with the lowest distance
    format long;
    r = (a+b)/2; %%our desired r value for this iteration
    a
    b
end
end
%% Writeup: In theory, our Schroderbisection will converge quadratically, even with multiple roots
%% and clustered roots in a small vicinity. We combine it with a geometric bisection,
%% which we get from picking one of our contestants as the geometric mean of the old interval.
%% we use geometric mean rather than arithmetic mean because machine numbers are much more dense
%% closer to zero, an arithmetic mean would not take that into consideration. Using multiple doctests to
%% empirically verify this theory, it has proved correct in all cases.

%%I made a lot of design decisions. They are listed throughout the code.

%%Extra credit ^3: if we choose the intervals using
%%the minimum bracketed interval of: {findbracket(p1),findbracket(p2),...,findbracket(p5)}, using the 5
%%points as the 5 previous contestants, this will converge even faster than
%%our current scheme!


    

    
    
    
    


