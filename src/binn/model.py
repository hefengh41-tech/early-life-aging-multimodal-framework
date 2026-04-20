import tensorflow as tf
from tensorflow.keras import layers, Model

class UpgradedBINN(Model):
    def __init__(self, mask_cpg_gene, mask_gene_path, dropout_rate=0.3):
        super().__init__()

        self.mask_cpg_gene = tf.constant(mask_cpg_gene, dtype=tf.float32)
        self.mask_gene_path = tf.constant(mask_gene_path, dtype=tf.float32)

        self.W1 = self.add_weight(shape=self.mask_cpg_gene.shape,
                                 initializer="random_normal",
                                 trainable=True)

        self.W2 = self.add_weight(shape=self.mask_gene_path.shape,
                                 initializer="random_normal",
                                 trainable=True)

        self.b1 = self.add_weight(shape=(self.mask_cpg_gene.shape[1],))
        self.b2 = self.add_weight(shape=(self.mask_gene_path.shape[1],))

        self.bn1 = layers.BatchNormalization()
        self.bn2 = layers.BatchNormalization()

        self.drop = layers.Dropout(dropout_rate)

    def call(self, x, training=False):
        x = tf.matmul(x, self.W1 * self.mask_cpg_gene) + self.b1
        x = tf.nn.relu(x)
        x = self.bn1(x, training=training)
        x = self.drop(x, training=training)

        x = tf.matmul(x, self.W2 * self.mask_gene_path) + self.b2
        x = self.bn2(x, training=training)

        return tf.nn.tanh(x)
