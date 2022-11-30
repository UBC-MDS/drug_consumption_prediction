# data pipe - drug consumption prediction
# author: Shaun Hutchinson, Jenit Jain, Ritisha Sharma
# date: 2022-11-29

all: results/eda/drug_frequency.png results/eda/personality_chart.png results/eda/numerical_bars.png results/eda/Age_valuecount.png results/eda/Gender_valuecount.png results/eda/Education_valuecount.png results/eda/Country_valuecount.png results/eda/Ethnicity_valuecount.png doc/breast_cancer_predict_report.md results/feature_importances.png results/svc_dummy_score.csv results/test_results.csv doc/drug_consumption_prediction_report.Rmd

# download and save data from url
data/raw/drug_consumption.csv: src/download_data.py
	python src/download_data.py --url=https://archive.ics.uci.edu/ml/machine-learning-databases/00373/drug_consumption.data --out_file=data/raw/drug_consumption.csv

# preprocess data (split data and clean strings)
data/processed/train.csv data/processed/test.csv: src/preprocess.py data/raw/drug_consumption.csv
	python src/preprocess.py --input_file_path=data/raw/drug_consumption.csv --preprocessed_out_dir=data/processed --processed_out_dir=data/prerocessed 

# exploratory data analysis (frequency chart, personality scores chart, value counts table, numerical features barplot)
results/eda/drug_frequency.png results/eda/personality_chart.png results/eda/numerical_bars.png results/eda/Age_valuecount.png results/eda/Gender_valuecount.png results/eda/Education_valuecount.png results/eda/Country_valuecount.png results/eda/Ethnicity_valuecount.png: src/drug_consumption_eda.py data/processed/train.csv
	python src/drug_consumption_eda.py --train=data/processed/train.csv --out_dir=results/eda

# train model using SVC and assess on testing data
results/feature_importances.png results/svc_dummy_score.csv results/test_results.csv: src/drug_consumption_prediction_model.py data/processed/training.feather
	python src/drug_consumption_prediction_model.py --data_path=data/processed/train.csv --result_path=results

# render Rmarkdown report
doc/drug_consumption_prediction_report.Rmd: doc/drug_consumption_prediction_report.Rmd doc/drug_prediction_refs.bib
	Rscript -e "rmarkdown::render('doc/drug_consumption_prediction_report.Rmd', output_format = 'html_document')"

clean: 
	rm -rf data/raw
	rm -rf data/processed
	rm -rf data/preprocessed
	rm -rf results/eda
	rm -rf results/analysis
	rm -rf doc/drug_consumption_prediction_report.Rmd doc/drug_consumption_prediction_report.html