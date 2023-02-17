clc; clear; close all;

%% // Problemin Tanimi

Func='Rosenbrock'; % Amac Fonksiyonu

NumVars = 5; % Karar Degiskenlerinin Boyutu
Range = [-5,5]; % Karar Degiskenlerinin Alt Sinir ve Ust Sinir Araligi

%% Firefly Algoritmasi Parametreleri

Pop = 25; % Atesböcegi Sayisi (Sürü Büyüklüðü)
MaxIter = 500; % Maksimum Ýterasyon Sayýsý

% Cekicilik Denklem Girdileri
Gamma = 1;   % Iþýk Soðurma Katsayýsý (0.01 ve 100 arasýnda)
Beta0 = 1;   % Cekicilik Katsayýsý Baz Deðeri
Alpha = 0.2; % Mutasyon Katsayýsý Rastlantý Deðeri (0 ve 1 arasýnda)
m = 2;

% Damping Deðeri
Damp = 0.99; % Mutasyon Katsayýsý Sönümleme Oraný

%% FireFly Algoritmasýný Bslngc

% Ateþböceði Yapýsý 
S_FireFly.Position = []; % Firefly Konumu
S_FireFly.Cost = []; % Firefly Cost Cozumu

FireFly = repmat(S_FireFly,Pop,1); % Olusumu % Populasyon Dizisini Baþlat

BestFireFly.Cost = inf; % Eniyi Deger

for i = 1 :Pop
    FireFly(i).Position = unifrnd(Range(1),Range(2),[1,NumVars]); % Pozisyon Bilgileri
    FireFly(i).Cost = feval(Func,FireFly(i).Position); % 
    
    if FireFly(i).Cost<=BestFireFly.Cost
        BestFireFly = FireFly(i); %
    end   
end

% En Ýyi Maliyet Deðerlerine Sahip Dizi
BestFireFlyCost = zeros(MaxIter, 1);

%% Ateþböceði Algoritmasý Ana Döngüsü

for Iter = 1 :MaxIter
N_FireFly = FireFly;
    for i = 1 :Pop
        for j = 1 :Pop  
        
            if FireFly(j).Cost <= FireFly(i).Cost
            
            Distance = norm (FireFly(i).Position - FireFly(j).Position); % Aradaki Uzaklik 
            Beta = Beta0*exp(-Gamma*Distance^m); % Cekicilik Degeri
          
            Ee = unifrnd(-0.5*(Range(2)-Range(1)),0.5*(Range(2)-Range(1))...
                ,[1,NumVars]);  % Rastgele Sayýmýz (-0.5,+0.5)
          
            N_FireFly(i).Position = FireFly(i).Position + Beta...
                * (FireFly(j).Position - FireFly(i).Position)...
                + Alpha*Ee; % Ateþ böceginin hareketi // yeni posizyonu
          
            N_FireFly(i).Position = max(N_FireFly(i).Position,Range(1)); % max degeri  
            N_FireFly(i).Position = min(N_FireFly(i).Position,Range(2)); % min degeri    
          
            N_FireFly(i).Cost = feval(Func,N_FireFly(i).Position); % Yeni Maliyet Cozumu
          
            if N_FireFly(i).Cost <= BestFireFly.Cost
                    BestFireFly = N_FireFly(i);
            end

            end
        end
    end

    FireFly = [N_FireFly
               FireFly 
               BestFireFly]; %#ok
    [~,SortOrder] = sort([FireFly.Cost]);
    FireFly = FireFly(SortOrder);
    FireFly = FireFly(1:Pop);
        
    % Nemli Mutasyon Katsayýsý
    Alpha = Alpha * Damp;
    % Þimdiye Kadarki En Ýyi Cozum Maliyeti
    BestFireFlyCost(Iter) = BestFireFly.Cost;
    % Bilgilerini Gösterme
    disp(['Iterasyon:',num2str(Iter),' / Best=',num2str(BestFireFlyCost(Iter))]);

end    

%% Sonuclari Gösterme
figure;
semilogy(BestFireFlyCost,'LineWidth',2);
xlabel('Iter');
ylabel('Best');
grid on;
