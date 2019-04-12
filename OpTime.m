N=6
Rep=10000


B=rand(N)>0.5;
Tocs=zeros(Rep, 3)

for r=1:Rep
    for k=1:N-1
        for kk=1:N-1
            tic
            isequal(B([k,k+1],kk), [0 , 1]);
            Tocs(r, 1)=toc;
            tic
            isequal([B(k,kk) ; B(k+1, kk)], [0 ; 1]);
            Tocs(r, 2)=toc;
            tic
            isequal([B(k,kk) , B(k+1, kk)], [0 , 1]);
            Tocs(r, 3)=toc;
        end
    end
end
T = {'B([k,k+1],kk)', '[B(k,kk) ; B(k+1, kk)]', '[B(k,kk) , B(k+1, kk)]'}

figure, subplot(1, 2, 1)
sinaplot(log10(Tocs).*(1+rand(Rep,3)/50)),
set(gca, 'xtick', 1:3)
set(gca, 'xticklabel', T)
ylabel('log_{10} seconds')

C=cumsum(Tocs);
subplot(1, 2, 2)
plot(C(:,1), '.b'), hold on, 
plot(C(:,2), '.r'), hold on
plot(C(:,3), '.g')
legend(T)
ylabel('seconds')

% figure, hist(log10(Tocs(:,1)./Tocs(:,2)), 100), axis([0 1 0 max(hist(log10(Tocs(:,1)./Tocs(:,2)), 100))*1.1])

