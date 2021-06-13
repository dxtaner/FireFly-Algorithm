clc; clear; close all;

%% // Problemin Tan�m�

Func='Rosenbrock'; % Amac Fonksiyonu

NumVars = 5; % Karar De�i�kenlerinin Boyutu
Range = [-5,5]; % Karar De�i�kenlerinin Alt Sinir ve Ust Sinir Araligi

%% Firefly Algoritmasi Parametreleri

Pop = 25; % Ate�b�ce�i Say�s� (S�r� B�y�kl���)
MaxIter = 500; % Maksimum �terasyon Say�s�

% Cekicilik Denklem Girdileri
Gamma = 1;   % I��k So�urma Katsay�s� (0.01 ve 100 aras�nda)
Beta0 = 1;   % Cekicilik Katsay�s� Baz De�eri
Alpha = 0.2; % Mutasyon Katsay�s� Rastlant� De�eri (0 ve 1 aras�nda)
m = 2;

% Damping De�eri
Damp = 0.99; % Mutasyon Katsay�s� S�n�mleme Oran�

%% FireFly Algoritmas�n� Bslngc

% Ate�b�ce�i Yap�s� 
S_FireFly.Position = []; % Firefly Konumu
S_FireFly.Cost = []; % Firefly Cost Cozumu

FireFly = repmat(S_FireFly,Pop,1); % Olusumu % Populasyon Dizisini Ba�lat

BestFireFly.Cost = inf; % Eniyi Deger

for i = 1 :Pop
    FireFly(i).Position = unifrnd(Range(1),Range(2),[1,NumVars]); % Pozisyon Bilgileri
    FireFly(i).Cost = feval(Func,FireFly(i).Position); % 
    
    if FireFly(i).Cost<=BestFireFly.Cost
        BestFireFly = FireFly(i); %
    end   
end

% En �yi Maliyet De�erlerine Sahip Dizi
BestFireFlyCost = zeros(MaxIter, 1);

%% Ate�b�ce�i Algoritmas� Ana D�ng�s�

for Iter = 1 :MaxIter
N_FireFly = FireFly;
    for i = 1 :Pop
        for j = 1 :Pop  
        
            if FireFly(j).Cost <= FireFly(i).Cost
            
            Distance = norm (FireFly(i).Position - FireFly(j).Position); % Aradaki Uzaklik 
            Beta = Beta0*exp(-Gamma*Distance^m); % Cekicilik Degeri
          
            Ee = unifrnd(-0.5*(Range(2)-Range(1)),0.5*(Range(2)-Range(1))...
                ,[1,NumVars]);  % Rastgele Say�m�z (-0.5,+0.5)
          
            N_FireFly(i).Position = FireFly(i).Position + Beta...
                * (FireFly(j).Position - FireFly(i).Position)...
                + Alpha*Ee; % Ate� b�ceginin hareketi // yeni posizyonu
          
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
        
    % Nemli Mutasyon Katsay�s�
    Alpha = Alpha * Damp;
    % �imdiye Kadarki En �yi Cozum Maliyeti
    BestFireFlyCost(Iter) = BestFireFly.Cost;
    % Bilgilerini G�sterme
    disp(['Iterasyon:',num2str(Iter),' / Best=',num2str(BestFireFlyCost(Iter))]);

end    

%% Sonuclari G�sterme
figure;
semilogy(BestFireFlyCost,'LineWidth',2);
xlabel('Iter');
ylabel('Best');
grid on;
