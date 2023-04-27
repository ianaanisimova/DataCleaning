SELECT * FROM NashvilleHousing; 

SELECT SaleDate, CONVERT(Date, SaleDate) FROM NashvilleHousing; 

Update NashvilleHousing SET SaleDate = CONVERT(Date, SaleDate); 

-- Populate Property Address data 

SELECT PropertyAddress FROM NashvilleHousing
Where PropertyAddress is null; 


SELECT * FROM NashvilleHousing
Where PropertyAddress is null
order by ParcelID; 

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing as a
JOIN NashvilleHousing as  b
ON a.ParcelID = b.ParcelID 
AND a."UniqueID " <> b."UniqueID "
WHERE a.PropertyAddress is null; 

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID 
AND a."UniqueID " <> b."UniqueID "
WHERE a.PropertyAddress is null; 

SELECT PropertyAddress FROM NashvilleHousing;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

FROM NashvilleHousing; 

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress TEXT;

UPDATE NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1); 


ALTER TABLE NashvilleHousing
ADD PropertySplitCity TEXT ;

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1); 

SELECT * FROM NashvilleHousing;


SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM NashvilleHousing; 

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress TEXT;


UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3);



ALTER TABLE NashvilleHousing
ADD OwnerSplitCity TEXT;

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2);
 

ALTER TABLE NashvilleHousing
ADD OwnerSplitState  TEXT;

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1); 


-- Updating Yes and No

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2; 



SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
WHEN SoldAsVacant = 'N' THEN 'No' 
ELSE SoldAsVacant
END 
FROM NashvilleHousing; 

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
WHEN SoldAsVacant = 'N' THEN 'No' 
ELSE SoldAsVacant
END ; 

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2; 

-- Remove Duplicates 


WITH RowNumCTE AS ( 
SELECT *, 
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
                 PropertyAddress,
                 SalePrice,
                 SaleDate,
                 LegalReference
               ORDER BY 
                 UniqueID 
                ) row_num
FROM NashvilleHousing
)
SELECT * FROM RowNumCTE 
WHERE row_num > 1
ORDER BY PropertyAddress; 


--  Deleting Unused Colums

SELECT * From NashvilleHousing; 

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate  ;

SELECT * From NashvilleHousing;  

 
