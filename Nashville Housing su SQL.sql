 SELECT *
 FROM PortfolioProjects.dbo.NashvilleHousing;


 SELECT CAST(SaleDate AS date) AS converted_saledate
 FROM PortfolioProjects.dbo.NashvilleHousing;


 SELECT *
 FROM PortfolioProjects.dbo.NashvilleHousing
 --WHERE PropertyAddress IS NULL
 ORDER BY ParcelID;


 SELECT SaleDate, CONVERT(Date,SaleDate)
 FROM PortfolioProjects.dbo.NashvilleHousing

 UPDATE NashvilleHousing
 SET SaleDate = CONVERT(Date,Saledate)

 ALTER TABLE NashvilleHousing
 ADD converted_saledate DATE;

 UPDATE NashvilleHousing
 SET converted_saledate = CONVERT(Date,Saledate)



 


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjects.dbo.NashvilleHousing AS a
 JOIN PortfolioProjects.dbo.NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;


 --Cleaning and dividing address into address, city

 SELECT PropertyAddress
 FROM PortfolioProjects.dbo.NashvilleHousing
 --WHERE PropertyAddress IS NULL

SELECT SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS address
FROM PortfolioProjects.dbo.NashvilleHousing

SELECT SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS city
FROM PortfolioProjects.dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))



SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProjects.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

-- CHANGING THE Y, N INTO YES AND NO

SELECT SoldAsVacant, CASE WHEN SoldAsvacant = 'Y' THEN 'YES'
						  WHEN SoldAsVacant = 'N' THEN 'NO'
						  ELSE SoldAsVacant
						  END
FROM PortfolioProjects.dbo.NashvilleHousing;


UPDATE NashvilleHousing 
SET SoldAsVacant = CASE WHEN SoldAsvacant = 'Y' THEN 'YES'
						  WHEN SoldAsVacant = 'N' THEN 'NO'
						  ELSE SoldAsVacant
						  END



-- REMOVE DUPLICATES
WITH rownumCTE AS (
SELECT *,
   ROW_NUMBER() OVER( 
   PARTITION BY ParcelID,
				PropertyAddress,
				Saleprice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID
					) rownum 
FROM PortfolioProjects.dbo.NashvilleHousing
)
DELETE
FROM rownumCTE
WHERE rownum > 1;


--Let's check if there are any duplicates left
WITH rownumCTE AS (
SELECT *,
   ROW_NUMBER() OVER( 
   PARTITION BY ParcelID,
				PropertyAddress,
				Saleprice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID
					) rownum 
FROM PortfolioProjects.dbo.NashvilleHousing
)
SELECT *
FROM rownumCTE
WHERE rownum > 1;


-- Delete non-used columns

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN SaleDate

