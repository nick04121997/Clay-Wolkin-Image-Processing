import tensorflow_parser
import image_loader
import numpy
import math
from scipy.stats import norm

def quick_setup():
    image_loader.scan_image_filenames()
    image_loader.reset_image_count()
    tensorflow_parser.start_tensorflow()

def init_tensorflow(directory, url):
    image_loader.setup_imagelist(directory,url)
    tensorflow_parser.start_tensorflow()

def process_images(): #returns mean and standard deviation of confidence for both sets
    num_images = image_loader.fetch_num_images()
    print 'Processing ',num_images, ' images'
    num_correct = 0
    for i in range(num_images):
        output = tensorflow_parser.full_tensorflow_cycle()
        if output == True:
		num_correct += 1
		print("Inceptionv3 matches label, current num correct:", num_correct)
	else: print("Inceptionv3 does not match label")
    prop_correct = float(num_correct) / float(num_images)
    return prop_correct


def two_sample_z(mean_a, mean_b, stddev_a, stddev_b, conf_level):
    normalized_parameter = (mean_a-mean_b)/(math.sqrt(stddev_a^2+stddev_b^2))
    if normalized_parameter>0:
        if 1-norm.cdf(normalized_parameter) < conf_level/2: print("Mean of population a > mean of population b to within given confidence level")
        print("No conclusion can be found")
    if normalized_parameter<0:
        if norm.cdf(normalized_parameter) < conf_level/2: print("Mean of population b > mean of population a to within given confidence level")
        print("No conclusion can be found")

def run_all():
    quick_setup()
    proportion = process_images()
    print 'Proportion identified correctly: ',proportion,' with ',proportion*image_loader.fetch_num_images(),' of ',image_loader.fetch_num_images(),' images'

run_all()
