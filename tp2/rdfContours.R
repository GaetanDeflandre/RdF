# -----------------------------------------------------------------------
# Extraction d'attributs de contours,
# Module RdF, reconnaissance de formes
# Copyleft (C) 2014, Universite Lille 1
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# -----------------------------------------------------------------------


# Chargement d'une image en niveaux de gris
rdfReadGreyImage <- function (nom) {
  image <- readImage (nom)
  if (length (dim (image)) == 2) {
    image
  } else {
    channel (image, 'red')
  }
}

# Lit un contour dans un fichier texte
rdfChargeFichierContour <- function (nom) {
  contour <- read.table (nom, )
  complex (real = contour$V1, imaginary = contour$V2)
}

# Contour d'une forme contenue dans une image
rdfContour <- function (image) {
  oc <- ocontour (image)
  complex (real = oc[[1]][,1], imaginary = oc[[1]][,2])
}

# Charge les contours d'une image binaire en vecteur de contexe
rdfLoadGreyImagetoComplexeBound <- function (nom) {
  img <- rdfReadGreyImage(nom)
  rdfContour(img)
}

# Algorithme de la corde pour la reduction d'un contour
rdfAlgorithmeCorde <- function (cont, dmax) {
  # Calcul des distances
  d <- rdfDistances (cont)
  # Si distance maxi inferieur au seuil, ne garder que les extremites
  if (max (d) <= dmax) {
    c (head (cont, 1), tail (cont, 1))
  # Sinon decouper en deux parties
  } else {
    # Point le plus eloigne
    loin <- which.max (d)
    # Reduire les deux sous chaines
    cont1 <- rdfAlgorithmeCorde (cont[1:loin], dmax)
    cont2 <- rdfAlgorithmeCorde (cont[loin:length (cont)], dmax)
    # Enlever un point et contatener
    c (cont1, tail (cont2, -1))
  }
}

# Calcul des distances entre les points et la corde
rdfDistances <- function (cont) {
  # Points extremes
  debut = head (cont, 1)
  fin = tail (cont, 1)
  # Calculer les distances
  abs(Im((cont - debut) * Conj(fin - debut))) / Mod(fin - debut)
  #rep (0, length (cont))
}

# Descripteurs de Fourier
rdfDescFourier <- function (cont) {
  fft(cont)
}

# Descripteurs de Fourier normalisés
rdfDescFourierNormalized <- function (cont) {
  fft(cont) / length(cont)
}

# Calcul la transformé
rdfDescFourierInverse <- function (desc) {
  fft(desc, TRUE)
}

# Annule un ratio des descripteurs de Fourier
rdfAnnuleDescFourier <- function (desc, ratio) {
    if(ratio==1){
        desc
    } else if(ratio==0) {
        desc*0
    } else {
        l <- length(desc)
        i <- (ratio*l)
        c(desc[0:i], desc[(i+1):l]*0)
    }
}
