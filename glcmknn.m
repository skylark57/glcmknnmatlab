clear
clc
close all
%pelatihan
cd('C:\Users\LENOVO\Documents\MATLAB\GLCM_KNN\DATASET\Training');
datasetku={'Pisang Ambon';'Pisang Cavendish';'Pisang Emas';'Pisang Kepok';'Pisang Raja'};
jmlkls=length(datasetku);
for n=1:jmlkls
    cd(char(datasetku(n)));
    datacitra=dir('*.png');
    jmldata=length(datacitra);
    for i=1:jmldata
        namafile=datacitra(i).name;
        citrai=rgb2gray(imread(namafile));

        fitur = graycoprops(graycomatrix(citrai, 'Offset', [-1 1])); %glcm
        fitur_mat(i+jmldata*(n-1),1)=fitur.Contrast;
        fitur_mat(i+jmldata*(n-1),2)=fitur.Correlation;
        fitur_mat(i+jmldata*(n-1),3)=fitur.Energy;
        fitur_mat(i+jmldata*(n-1),4)=fitur.Homogeneity;

        kelas(i+jmldata*(n-1))=n;
    end
    cd('..');
end

%pengujian
model = fitcknn(fitur_mat,kelas'); %model knn
cd('C:\Users\LENOVO\Documents\MATLAB\GLCM_KNN\DATASET\Testing1\')

 for j=1:jmlkls
    nama=sprintf('Pisang%d.png',j);
    a=rgb2gray(imread(nama));
    m=graycomatrix(a, 'Offset', [-1 1]);
    g=graycoprops(m);
    uji(j,1)=g.Contrast;
    uji(j,2)=g.Correlation;
    uji(j,3)=g.Energy;
    uji(j,4)=g.Homogeneity;

    target(j)=j;
    klasifikasi(j)=model.predict(uji(j,:)); %melakukan prediksi dari model knn
    if klasifikasi(j)==target(j)
        hasil(j)={'Benar'};
    else
        hasil(j)={'Salah'};
    end

end

[{'Contrast','Correlation','Energy','Homogeneity','Target','Kelas','Hasil'};
    num2cell([uji target' klasifikasi']) hasil']

% cm = confusionmat(target',klasifikasi')
% akurasi = sum(diag(cm)/sum(sum(cm)))