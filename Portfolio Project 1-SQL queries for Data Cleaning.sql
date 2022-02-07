Select *
From PortfolioProject.dbo.[Nashville Housing]

--Standardizing date format

Select SaleDateConverted, Convert(Date, SaleDate)
From PortfolioProject.dbo.[Nashville Housing]

Update [Nashville Housing]
Set SaleDate = Convert(Date, SaleDate)

Alter Table [Nashville Housing]
Add SaleDateConverted Date;

Update [Nashville Housing]
Set SaleDateConverted = Convert(Date, SaleDate)


--Populating Propert Address data, populating property address that is absent using parcelID
Select *
From PortfolioProject.dbo.[Nashville Housing]
--Where PropertyAddress  is null
order by ParcelID

--Joining where ParcelID is same but not the same row (unique ID is not same)
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.[Nashville Housing] a
JOIN PortfolioProject.dbo.[Nashville Housing] b
on a.ParcelID= b.ParcelID
AND a.[UniqueID] <> b. [UniqueID]
Where a.PropertyAddress is null

--Update to change Null Property Address
Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.[Nashville Housing] a
JOIN PortfolioProject.dbo.[Nashville Housing] b
on a.ParcelID= b.ParcelID
AND a.[UniqueID] <> b. [UniqueID]


--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.[Nashville Housing]
--Where PropertyAddress is null
--order by Parcel ID
--Taking out Comma
Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.[Nashville Housing]


--Create two new columns and add value in for address and city
Alter Table [Nashville Housing]
Add PropertySplitAddress Nvarchar(255);

Update [Nashville Housing]
SET PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1 )

Alter Table [Nashville Housing ]
Add PropertySplitCity Nvarchar(255); 

Update [Nashville Housing]
Set PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) 

Select*
From PortfolioProject.dbo.[Nashville Housing]



--Looking at owner address and seperating using parcename (easier than previous substring method)

Select OwnerAddress
From PortfolioProject.dbo.[Nashville Housing]

Select
PARSENAME (REPLACE(Owneraddress, ',', '.'), 3),
PARSENAME (REPLACE(Owneraddress, ',', '.'), 2),
PARSENAME (REPLACE(Owneraddress, ',', '.'), 1)
From PortfolioProject.dbo.[Nashville Housing]


Alter Table [Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitAddress = PARSENAME (REPLACE(Owneraddress, ',', '.'), 3)

Alter Table [Nashville Housing ]
Add OwnerSplitCity Nvarchar(255); 

Update [Nashville Housing]
Set OwnerSplitCity = PARSENAME (REPLACE(Owneraddress, ',', '.'), 2)

Alter Table [Nashville Housing ]
Add OwnerSplitState Nvarchar(255); 

Update [Nashville Housing]
Set OwnerSplitState = PARSENAME (REPLACE(Owneraddress, ',', '.'), 1)

Select*
From PortfolioProject.dbo.[Nashville Housing]

--Change Y and N to Yes and No in "Sold as Vacant" field using case statements

Select Distinct(soldasvacant), Count(SoldasVacant)
From PortfolioProject.dbo.[Nashville Housing]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant ='Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
End
From PortfolioProject.dbo.[Nashville Housing]

 Update [Nashville Housing]
 SET SoldAsVacant=CASE When SoldAsVacant ='Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
End


-----------------------------------------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates using row number, CTE, and partition by
WITH RowNumCTE AS(
Select *,
	Row_Number() Over( 
	Partition BY ParcelID,
						PropertyAddress,
						SalePrice,
						SaleDate, 
						LegalReference
						Order BY
							UniqueID
							) row_num
From PortfolioProject.dbo.[Nashville Housing]
--order by ParcelID
)
SELECT *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

					

From PortfolioProject.dbo.[Nashville Housing]

Select *
From PortfolioProject.dbo.[Nashville Housing]




---Delete Unused Columns to make data more user friendly

Select*
From PortfolioProject.dbo.[Nashville Housing]

ALTER TABLE PortfolioProject.dbo.[Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


--Importing Data