Training accuracy: 74.6% at 20 iterations. Validation accuracy: 66.7%

I had to use RoboFlow to improve this cursed dataset, generate more sample images, and divide the data into Training, Validation, and Test folders.

In my new dataset:
TRAIN SET: 1869 images
VALIDATION SET: 180 images
TEST SET: 88 images

Augmentations and modifications:
Flip: Horizontal
Brightness: Between -25% and +25%
Exposure: Between -25% and +25%

Original Kaggle dataset: https://www.kaggle.com/datasets/erdalbasaran/eardrum-dataset-otitis-media/code

Each otoscope sample in the database was evaluated by three ENT specialists.
The total number of images in the dataset =956
Normal Tympanic membrane=535
Acute Otitis Media (AOM)=119
Chronic suppurative Otitis Media =63
Earwax =140
Otitis externa =41,
Ear ventilation tube=16
Foreign bodies in the ear=3
Pseudo membranes=11
Tympanoskleros=28
The samples from different classes were stored in the specified folders named according to OM types.
The low-quality images due to lack of light, hand-shake, etc., were also isolated from the database.

(Images for each label are so disproportionate, SOS. The model is definitely biased lmao.)

I also designed a cardboard otoscope that connects to the phone's camera.
