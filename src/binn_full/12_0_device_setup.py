import tensorflow as tf

def get_strategy():
    try:
        resolver = tf.distribute.cluster_resolver.TPUClusterResolver()
        tf.config.experimental_connect_to_cluster(resolver)
        tf.tpu.experimental.initialize_tpu_system(resolver)
        strategy = tf.distribute.TPUStrategy(resolver)
        device = "TPU"
    except:
        gpus = tf.config.list_physical_devices("GPU")
        if gpus:
            strategy = tf.distribute.MirroredStrategy()
            device = "GPU"
        else:
            strategy = tf.distribute.get_strategy()
            device = "CPU"

    print("Using device:", device)
    return strategy
