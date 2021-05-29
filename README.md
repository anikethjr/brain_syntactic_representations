# Can fMRI reveal the representation of syntactic structure in the brain?

The code base for our paper on understanding syntactic representations in the human brain using naturalistic fMRI data. We explain how to reproduce our results in detail and also point to our preprocessed data.

## Dependencies

All of the results were obtained using a machine with 28 CPU cores, 126 GB RAM and a CUDA-capable GPU in a private HPC facility. Our analyses were performed using iPython notebooks with Python3.6 kernels. We have tested this code on CentOS Linux 8. We recommend using a Linux-based environment to run our code. The analysis pipeline is fairly compute-intensive and it took us about 4 days to run it. Expect the runtime to be significantly longer if you are using a system with less than 12 cores. Our code does not make very heavy use of a GPU. Thus, an entry level graphics card such as an Nvidia RTX 2060 should be sufficient. It is possible to run the code even without a GPU but it might take longer to generate some features.

The Python packages needed to run our code can be installed by running the `install_python_dependencies.sh` script:
```bash
bash install_python_dependencies.sh
```
You will also have to install FSL (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FSL) which is needed to transform results to MNI space.

The graph embeddings-based features used in our paper are computed using sub2vec [1]. Please download the code written by the original authors for this algorithm from here http://people.cs.vt.edu/~bijaya/codes/sub2vec.zip and extract the code to a folder called `sub2vec`.

Clone the code for the incremental top-down parser [2, 3] from this repo - https://github.com/roarkbr/incremental-top-down-parser to the folder containing our code. This is needed to generate the syntactic surprisal and InConTreGE features. This code must be in a folder called `incremental-top-down-parser`.

Finally, download the ROIs created by Fedorenko et al. (2010) [4] from here - https://osf.io/2gaw3/ and extract the files to the folder containing our code. These are required to create the image of the ROIs.

## Reproducing Our Results

The preprocessed fMRI data we use have been uploaded here - https://drive.google.com/file/d/1aYEZZSyrlo0UqswDBUiGzE3kGl3RcCn8/view?usp=sharing. Please download the file and extract it to the directory in which the code has been cloned. The data should be saved in a folder called `sub_space_data`. 

Note that we cannot provide the anatomical data needed to visualize subject space results to protect the anonymity of the subjects. However, we provide the binary masks and transforms needed to transform subject space results to MNI space. These were obtained using pycortex.

Also, we provide all of the main files needed to generate our figures and tables since running our full pipeline can take a long time. These include the features we generate, the R^2 scores and the significance testing results among others. The features are included along with the code in the `features` folder. The R^2 scores and significance testing results files need to be downloaded from https://drive.google.com/file/d/103erZKvjPeia71-1TJ5YV7u048mJ1Afr/view?usp=sharing and the two folders `predictions` and `predictions_mni` need to copied over to the folder containing the code.

Please follow these steps to reproduce our results using this codebase:

1. Upon extracting the aforementioned file, the preprocessed fMRI data can be found in the folder called `sub_space_data`. 

2. The text which is presented to the subjects is in the `chapter9.txt` file. The string on each line of the file is sequentially presented (there are 5176 lines). The + symbol is a fixation cross that is periodically shown to the subjects. Since we use word-level features, all of the files which contain these features are numpy arrays of the form (5176, number of feature dimensions). The rows which correspond to the presentation of a + are filled with zeros.

3. Generate the complexity metrics - Node Count (NC), Syntactic Surprisal (SS), Word Frequency (WF) and Word Length (WL), for every presented word by running the `generate_node_count.ipynb`, `generate_syntactic_surprisal.ipynb`, `generate_word_frequency.ipynb`, `generate_word_frequencies_and_word_lengths.ipynb` notebooks respectively. The outputs are stored in the `features` folder as `node_count.npy`, `syntactic_surprisal.npy`, `word_frequency.npy` and `word_length.npy`.

4. Generate the POS tags of the presented words using the `generate_pos_tags.ipynb` notebook. The output is stored in the `features` folder as `pos_tags.npy`.

5. Generate the DEP tags of the presented words using the `generate_dep_tags.ipynb` notebook. The output is stored in the `features` folder as `dep_tags.npy`.

6. Generate the punctuation-based feature space by running the `generate_punct.ipynb` notebook. This feature space is extracted from POS and DEP tags since it is just a subset of these features. The output is stored in the `features` folder as `punct_final.npy`.

7. In order to generate the ConTreGE Comp vectors, we first need to generate the subtrees to be encoded. This is done by running the `generate_contrege_comp_subtrees.ipynb` notebook. These subtrees are stored in the `contrege_comp_subtrees` folder. Then, we run the `generate_contrege_comp_vectors_using_sub2vec.ipynb` notebook to generate 5 sets of ConTreGE Comp vectors using sub2vec. These are stored in the `features` folder (called as `contrege_comp_set_0.npy`, `contrege_comp_set_1.npy`, `contrege_comp_set_2.npy`, `contrege_comp_set_3.npy`, `contrege_comp_set_4.npy`). We include all of the sets we generated and used in our analyses since these vectors are stochastic and can vary from run to run.

8. We need to follow steps similar to those used to generate ConTreGE Comp so as to generate the ConTreGE Incomp vectors. We first need to generate the subtrees to be encoded by running the `generate_contrege_incomp_subtrees.ipynb` notebook. These subtrees are stored in the `contrege_incomp_subtrees` folder. Then, we run the `generate_contrege_incomp_vectors_using_sub2vec.ipynb` notebook to generate 5 sets of ConTreGE Incomp vectors using sub2vec. These are stored in the `features` folder (called as `contrege_incomp_set_0.npy`, `contrege_incomp_set_1.npy`, `contrege_incomp_set_2.npy`, `contrege_incomp_set_3.npy`, `contrege_incomp_set_4.npy`). Again, we include all of the sets we generated and used in our analyses since these vectors are also stochastic and can vary from run to run.

9. The InConTreGE vectors are generated using the partial parses output by the aforementioned incremental top-down parser. To get the subtrees which are representative of these partial parses, run the `generate_incontrege_subtrees.ipynb` notebook. Then, run the `generate_incontrege_vectors_using_sub2vec.ipynb` notebook to generate 5 sets of InConTreGE vectors using sub2vec. These are stored in the `features` folder (called as `incontrege_set_0.npy`, `incontrege_set_1.npy`, `incontrege_set_2.npy`, `incontrege_set_3.npy`, `incontrege_set_4.npy`). We include all of the sets we generated and used in our analyses since these vectors are stochastic and can vary from run to run.

10. To generate the BERT embeddings-based semantic features, run the `generate_incremental_bert_embeddings.ipynb` notebook. The output is stored in the `features` folder as `incremental_bert_embeddings_layer12_PCA_dims_15.npy`.

11. Now that all of the individual features are ready, we can build the hierarchical feature groups used in the paper. Run the `generate_hierarchical_feature_groups.ipynb` notebook to build them. Note that the punctuation-based feature is not explicitly added to feature groups that contain POS and DEP tags. This is because POS and DEP tags already contain the punctuation feature in them. This step generates the following important files in the `features` folder:
	1. node_count_punct.npy = `{NC, PU}`
	2. syntactic_surprisal_punct.npy = `{SS, PU}`
	3. word_frequency_punct.npy = `{WF, PU}`
	4. word_length_punct.npy = `{WL, PU}`
	5. all_complexity_metrics_punct.npy = `{CM, PU}`
	6. pos_dep_tags_all_complexity_metrics.npy = `{PD, CM, PU}`
	7. contrege_comp_set_X_pos_dep_tags_all_complexity_metrics.npy = `{CC, PD, CM, PU}`
	8. contrege_incomp_set_X_pos_dep_tags_all_complexity_metrics.npy = `{CI, PD, CM, PU}`
	9. incontrege_set_X_pos_dep_tags_all_complexity_metrics.npy = `{INC, PD, CM, PU}`
	10. bert_PCA_dims_15_contrege_incomp_set_X_pos_dep_tags_node_count.npy = `{BERT, CI, PD, CM, PU}`

12. We can then start training Ridge regression models and using these trained models to make predictions (training and prediction is done in a cross validated fashion as described in the paper). Run the `predictions_master_script.ipynb` notebook in order to generate all of the predictions. Predictions made using each feature group will be stored in separate subfolders in the `predictions` folder and will be in subject space (these subfolders will be named after the numpy files used to make the predictions). The R^2 scores for each subject and feature group are stored in the files of the form `SubjectName_r2s.npy`.

13. The prediction results obtained using the ConTreGE Comp, ConTreGE Incomp and InConTreGE vectors need to be averaged across the 5 sets. Run the `aggregate_contrege_results_across_sets.ipynb` notebook to do this. The script outputs the averaged results to subfolders that start with the `aggregated` prefix in the `predictions` folder.

14. After obtaining the predictions, we can start testing our results for significance. First, we test the significance of the R^2 scores obtained using punctuations only by performing a permutation test. This test is run by executing the `significance_testing_permutation.ipynb` notebook. Running this notebook will generate files of the form `SubjectName_sig.npy` in the `punct_final` subfolder of `predictions`. These subject space files indicate voxels for which the R^2 scores produced using punctuations are significant.

15. Then, we test for the significance of the differences in R^2 scores between consecutive hierarchical feature groups by running the `difference_significance_testing_bootstrap.ipynb` notebook. This generates subfolders of the form `{features in group 1}_diff_{features in group 2}` that contain files of the form `SubjectName_sig_boot.npy` in the `predictions` folder. These subject space files indicate voxels for which the difference in R^2 scores between group 1 and group 2 (= R^2_group1 - R^2_group2) are significant. 
Note that:
	1. node_count_punct_diff_punct_final = `{NC, PU} - {PU}`
	2. syntactic_surprisal_punct_diff_punct_final = `{SS, PU} - {PU}`
	3. word_frequency_punct_diff_punct_final = `{WF, PU} - {PU}`
	4. word_length_punct_diff_punct_final = `{WL, PU} - {PU}`
	5. all_complexity_metrics_punct_diff_punct_final = `{CM, PU} - {PU}`
	6. pos_dep_tags_all_complexity_metrics_diff_all_complexity_metrics_punct = `{PD, CM, PU} - {CM, PU}`
	7. aggregated_contrege_comp_pos_dep_tags_all_complexity_metrics_diff_pos_dep_tags_all_complexity_metrics = `{CC, PD, CM, PU} - {PD, CM, PU}`
	8. aggregated_contrege_incomp_pos_dep_tags_all_complexity_metrics_diff_pos_dep_tags_all_complexity_metrics = `{CI, PD, CM, PU} - {PD, CM, PU}`
	9. aggregated_incontrege_pos_dep_tags_all_complexity_metrics_diff_pos_dep_tags_all_complexity_metrics = `{INC, PD, CM, PU} - {PD, CM, PU}`
	10. aggregated_bert_PCA_dims_15_contrege_incomp_pos_dep_tags_node_count_diff_aggregated_contrege_incomp_pos_dep_tags_node_count = `{BERT, CI, PD, CM, PU} - {CI, PD, CM, PU}`

16. False Discovery Rate correction is then performed for all of the significance tests as described in the paper by running the `perform_FDR_correction.ipynb` notebook. For the punctuation feature, we obtain files of the form `SubjectName_sig_group_corrected.npy` and for all the other tests, files of the form `SubjectName_sig_bootstrap_group_corrected.npy` are obtained. These files are stored in the same subfolders of the `predictions` folder that contain the uncorrected p-val files.

17. To generate the brain maps shown in the paper, we need to transform the significance testing results and R^2 scores that are in subject space to MNI space. Run the `mni_transform.ipynb` notebook to perform this transformation. The transformed files are saved in the `predictions_mni` folder. Note that running the aforementioned notebook requires FSL to be installed.

18. Finally, running the `create_figures.ipynb` notebook generates the figures in our paper in a folder called `figures`. R^2+ figures are stored in `r2plus_figures` subfolder and the significance testing results are stored in the `sig_figures` subfolder. `blank_plot_of_rois.png` is a plot showing the ROIs and the ROI analysis figures are saved in the `roi_figures` subfolder.

The syntactic information analysis can be carried out by following these steps:

1. Run the `generate_ancestor_data_for_information_analysis.ipynb` notebook to generate numpy files that encode the ancestor information. These files are stored in the `ancestor_information_analysis` folder.

2. Then run the `syntactic_information_analysis.ipynb` notebook to perform the prediction analysis. The notebook generates a CSV file called `final_syntactic_information_analysis_results.csv` that contains the prediction accuracies and the associated p-vals. The last cell of the notebook shows the label distribution for each level.

## References

1. Adhikari, Bijaya, et al. "Sub2vec: Feature learning for subgraphs." Pacific-Asia Conference on Knowledge Discovery and Data Mining. Springer, Cham, 2018.

2. Roark, Brian. "Probabilistic top-down parsing and language modeling." Computational linguistics 27.2 (2001): 249-276.

3. Roark, Brian, et al. "Deriving lexical and syntactic expectation-based measures for psycholinguistic modeling via incremental top-down parsing." Proceedings of the 2009 conference on empirical methods in natural language processing. 2009.

4. Fedorenko, Evelina, et al. "New method for fMRI investigations of language: defining ROIs functionally in individual subjects." Journal of neurophysiology 104.2 (2010): 1177-1194.