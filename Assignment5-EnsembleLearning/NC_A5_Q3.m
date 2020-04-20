c=10;
p=0.6;
p2=0.85;

% 3.a) 

function out=majority_vote(c,p,p2)
  out = 0;
  #cases when strong classifier predicted correct
  for i = (floor(c/2)):c
    coeff = nchoosek(c,i);
    out = out + (coeff*power(p,i)*power((1-p),(c-i))*p2);
  end
  #cases when strong classifier predicted wrong 
  for i = (floor(c/2)+1):c
    coeff = nchoosek(c,i);
    out = out + (coeff*power(p,i)*power((1-p),(c-i))*(1-p2));
  end
end

majority_vote(c,p,p2)

% 3.b)

function out=weighted_majority_vote(c,p,p2,w1)
  #######    1.)for the case when strong classifier is always right
  
  #w1 is the weight of strong classifier
  #w2 is the weight of each of the weak classifiers
  w2=(1-w1)/c; # 1-weight_strong_clf divided by 10 (number of weak clf), so each weak clf has the same weight
  the_rest=1-w1 ; # this is how much is left when we subtract the weight of str.clf.; when it is below 0.5 it means we have majority
  count=0;
  #to get a majority of weight, we need to have sum of weights over 0.5
  while (the_rest>0.5)
    the_rest=the_rest-w2;
    #count will represent the min. amount of weak classifiers we need (together with the strong clf.) to have a majority
    count=count+1;
  endwhile
  # out is Pr_maj
  out = 0;
  for i = count:c
    coeff = nchoosek(c,i);
    out = out + (coeff*power(p,i)*power((1-p),(c-i))*p2);
  end
  
  ###### 2.) for case when strong class.predicts wrong
  
  rest=1;
  # count2 will be the minimum amount of weak classifiers we need to have a majority ( strong clf.predicted wrong)
  count2=0;
  # just a flag_var for easier computing after
  flag = 0;
  # now we subtract from 1 (rest) weigths of each week classifier to see how many of them we need to obtain the majority
  while (rest>0.5)
    rest=rest-w2;
    # count2 same as count, minimum amount of weak classifiers
    count2=count2+1;
    # this case below means that there is no possibility for majority vote for correct decision when strong classifier predicts wrong ( no combinations 
    # so Pr = 0) 
    if((count2==c) && (rest>=0.5))  #all weak classifiers are correct, but their weights are still lower or equal to 0.5 
      flag = 1;
      break
    end
  endwhile
  
  if (flag==1) # no combinations, no probability
    out=out+0;
  end 
  if (flag==0) #majority of weak classifiers accomplished 
    for i = count2:c
    coeff = nchoosek(c,i);
    out = out + (coeff*power(p,i)*power((1-p),(c-i))*(1-p2));
    end
  end    
end

# assigning weights from 0.1 to 1 for strong classifier
x = 0.1 : 0.1 : 1;
pr=[];
for i= 1:length(x)
  pr = [pr,weighted_majority_vote(c,p,p2,x(i))];
endfor
figure(1)
plot(x,pr)
title("Weighted majority vote")
xlabel("Weight of a strong classifier")
ylabel("Probability")

% 3.d)

error = 0 : 0.01 : 1;
weights=[];
for i=1:length(error)
  weights= [weights, log((1-error(i))/error(i))];
endfor
figure(2)
plot(error,weights)
title("Classifier's weight for different error rate")
xlabel("Error")
ylabel("Classifier's weight")